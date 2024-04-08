/*
 * File: ex.scala                                                              *
 * Created Date: 2023-02-25 10:19:59 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-08 08:30:21 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 HerdWare                                                 *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.betizu

import chisel3._
import chisel3.util._

import prj.common.gen._
import prj.common.lbus._
import prj.common.mbus._
import prj.common.isa.base._


class ExStage(p: BetizuParams) extends Module {
  val io = IO(new Bundle {    
    val b_in = Flipped(new GenRVIO(p, new ExCtrlBus(p), new DataBus(p)))
    
    val i_br_next = Input(new BranchBus(p))
    val o_br_new = Output(new BranchBus(p))
    val o_byp = Output(Vec(p.nGprBypass, new BypassBus(p)))

    val b_dmem = new MBusIO(p.pL0DBus)
    val b_rd = Flipped(new GprWriteIO(p))
  })  

  val m_alu = Module(new Alu(p))
  val m_bru = Module(new Bru(p))
  val m_buf = Module(new GenFifo(p, new ExBufferBus(p), UInt(0.W), 4, p.nExBufferDepth, 1, 1))

  val init_st = Wire(new GenVBus(p, UInt(0.W), UInt(p.nDataBit.W)))

  init_st := DontCare
  init_st.valid := false.B

  val r_st = RegInit(init_st)

  val w_multi = Wire(Bool())
  val w_empty = Wire(Bool())
  val w_wait_req = Wire(Bool())
  val w_wait_buf = Wire(Bool())
  val w_wait_ack = Wire(Bool())
  val w_res_one = Wire(UInt(p.nDataBit.W))
  val w_res_multi = Wire(UInt(p.nDataBit.W))

  // ******************************
  //            REQUEST
  // ******************************
  w_multi := false.B
  w_wait_req := false.B
  w_wait_buf := false.B

  // ------------------------------
  //              ALU
  // ------------------------------
  m_alu.io.b_in.valid := io.b_in.valid & (io.b_in.ctrl.get.int.unit === INTUNIT.ALU) & w_empty
  m_alu.io.b_in.ctrl.get.uop := io.b_in.ctrl.get.int.uop
  m_alu.io.b_in.ctrl.get.pc := io.b_in.ctrl.get.info.pc
  m_alu.io.b_in.ctrl.get.ssign := io.b_in.ctrl.get.int.ssign
  m_alu.io.b_in.data.get.s1 := io.b_in.data.get.s1
  m_alu.io.b_in.data.get.s2 := io.b_in.data.get.s2
  m_alu.io.b_in.data.get.s3 := io.b_in.data.get.s3

  when (io.b_in.ctrl.get.int.unit === INTUNIT.ALU) {
    w_wait_req := false.B
  }

  // ------------------------------
  //              BRU
  // ------------------------------
  m_bru.io.b_in.valid := io.b_in.valid & (io.b_in.ctrl.get.int.unit === INTUNIT.BRU) & w_empty
  m_bru.io.b_in.ctrl.get.uop := io.b_in.ctrl.get.int.uop
  m_bru.io.b_in.ctrl.get.pc := io.b_in.ctrl.get.info.pc
  m_bru.io.b_in.ctrl.get.ssign := io.b_in.ctrl.get.int.ssign
  m_bru.io.b_in.data.get.s1 := io.b_in.data.get.s1
  m_bru.io.b_in.data.get.s2 := io.b_in.data.get.s2
  m_bru.io.b_in.data.get.s3 := io.b_in.data.get.s3

  m_bru.io.i_br_next := io.i_br_next

  when (io.b_in.ctrl.get.int.unit === INTUNIT.BRU) {
    w_wait_req := ~m_bru.io.b_in.valid
  }

  // ------------------------------
  //              LSU
  // ------------------------------
  io.b_dmem.req.valid := io.b_in.valid & io.b_in.ctrl.get.lsu.use & ~w_wait_buf
  io.b_dmem.req.ctrl.rw := io.b_in.ctrl.get.lsu.st
  io.b_dmem.req.ctrl.addr := m_alu.io.b_out.data.get
  io.b_dmem.req.ctrl.size := DontCare
  switch (io.b_in.ctrl.get.lsu.size) {
    is (LSUSIZE.B) {
      io.b_dmem.req.ctrl.size := SIZE.B1.U
    }
    is (LSUSIZE.H) {
      io.b_dmem.req.ctrl.size := SIZE.B2.U
    }
    is (LSUSIZE.W) {
      io.b_dmem.req.ctrl.size := SIZE.B4.U
    }
  }

  r_st.valid := r_st.valid & ~io.b_dmem.write.ready
  io.b_dmem.write.valid := r_st.valid
  io.b_dmem.write.data := r_st.data.get

  when (io.b_in.ctrl.get.lsu.use) {
    w_multi := io.b_in.valid
    when (io.b_in.ctrl.get.lsu.st) {
      w_wait_req := ~io.b_dmem.req.ready | (r_st.valid & ~io.b_dmem.write.ready)

      when (~w_wait_req & ~w_wait_buf) {
        r_st.valid := true.B
        r_st.data.get := io.b_in.data.get.s3
      }
    }.otherwise {
      w_wait_req := ~io.b_dmem.req.ready
    }    
  }

  when (io.b_in.valid & io.b_in.ctrl.get.lsu.st) {
    r_st.valid := true.B
    r_st.data.get := io.b_in.data.get.s3
  }

  // ------------------------------
  //             BUFFER
  // ------------------------------
  m_buf.io.i_flush := false.B

  w_wait_buf := ~m_buf.io.b_in(0).ready
  w_empty := ~m_buf.io.b_out(0).valid

  m_buf.io.b_in(0).valid := io.b_in.valid & io.b_in.ctrl.get.lsu.use & ~w_wait_req
  m_buf.io.b_in(0).ctrl.get.info := io.b_in.ctrl.get.info
  m_buf.io.b_in(0).ctrl.get.lsu := io.b_in.ctrl.get.lsu
  m_buf.io.b_in(0).ctrl.get.gpr := io.b_in.ctrl.get.gpr

  m_buf.io.b_in(0).ctrl.get.multi := DontCare
  when (io.b_in.valid & io.b_in.ctrl.get.lsu.use) {
    m_buf.io.b_in(0).ctrl.get.multi := MULTI.MEM
  }

  // ******************************
  //        ACKNOWLEDGEMENT
  // ******************************
  w_wait_ack := false.B
  w_res_one := DontCare
  w_res_multi := DontCare

  // ------------------------------
  //              ALU
  // ------------------------------
  m_alu.io.b_out.ready := true.B

  when (io.b_in.ctrl.get.int.unit === INTUNIT.ALU) {
    w_res_one := m_alu.io.b_out.data.get
  }

  // ------------------------------
  //              BRU
  // ------------------------------
  io.o_br_new := m_bru.io.o_br_new

  m_bru.io.b_out.ready := true.B

  when (io.b_in.ctrl.get.int.unit === INTUNIT.BRU) {
    w_res_one := m_bru.io.b_out.data.get
  }

  // ------------------------------
  //              LSU
  // ------------------------------
  when (m_buf.io.b_out(0).ctrl.get.lsu.ld) {
    w_wait_ack := ~io.b_dmem.read.valid
    w_res_multi := io.b_dmem.read.data
  }

  // ------------------------------
  //             BUFFER
  // ------------------------------
  io.b_dmem.read.ready := m_buf.io.b_out(0).ctrl.get.lsu.ld

  m_buf.io.b_out(0).ready := false.B
  switch (m_buf.io.b_out(0).ctrl.get.multi) {
    is (MULTI.MEM) {
      m_buf.io.b_out(0).ready := io.b_dmem.read.valid
    }
  }

  // ******************************
  //              GPR
  // ******************************
  // ------------------------------
  //             BYPASS
  // ------------------------------
  io.o_byp(0).valid := m_buf.io.b_out(0).valid & m_buf.io.b_out(0).ctrl.get.gpr.en
  io.o_byp(0).ready := ~w_wait_ack
  io.o_byp(0).addr := m_buf.io.b_out(0).ctrl.get.gpr.addr
  io.o_byp(0).data := w_res_multi

  for (eb <- 1 until p.nExBufferDepth) {
    io.o_byp(eb).valid := m_buf.io.o_val(eb).valid & m_buf.io.o_val(eb).ctrl.get.gpr.en
    io.o_byp(eb).ready := false.B
    io.o_byp(eb).addr := m_buf.io.o_val(eb).ctrl.get.gpr.addr
    io.o_byp(eb).data := DontCare
  }

  if (p.useIdStage) {
    io.o_byp(p.nExBufferDepth).valid := io.b_in.valid & io.b_in.ctrl.get.gpr.en
    io.o_byp(p.nExBufferDepth).ready := ~w_wait_req & ~w_multi
    io.o_byp(p.nExBufferDepth).addr := io.b_in.ctrl.get.gpr.addr
    io.o_byp(p.nExBufferDepth).data := w_res_one
  }

  // ------------------------------
  //             WRITE
  // ------------------------------
  when (m_buf.io.b_out(0).valid) {
    io.b_rd.valid := m_buf.io.b_out(0).ctrl.get.gpr.en & ~w_wait_ack
    io.b_rd.addr := m_buf.io.b_out(0).ctrl.get.gpr.addr
    io.b_rd.data := w_res_multi
  }.otherwise {
    io.b_rd.valid := io.b_in.valid & io.b_in.ctrl.get.gpr.en & ~w_wait_req & ~w_multi
    io.b_rd.addr := io.b_in.ctrl.get.gpr.addr
    io.b_rd.data := w_res_one
  }

  // ******************************
  //             LOCK
  // ******************************
  io.b_in.ready := ~(w_wait_req | w_wait_buf)

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    // ------------------------------
    //            SIGNALS
    // ------------------------------

  }
}

object ExStage extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new ExStage(BetizuConfigBase),
    firtoolOpts = Array.concat(
      Array(
        "--disable-all-randomization",
        "--strip-debug-info",
        "--split-verilog"
      ),
      args
    )      
  )
}