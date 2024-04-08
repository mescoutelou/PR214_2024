/*
 * File: ex.scala                                                              *
 * Created Date: 2023-02-25 10:19:59 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-08 02:21:06 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
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
    val o_byp = if (p.useIdStage) Some(Output(new BypassBus(p))) else None

    val b_dmem = new MBusIO(p.pL0DBus)
    val b_rd = Flipped(new GprWriteIO(p))
  })  

  val m_l0d = Module(new LBusMBus(p.pL0DBuffer))

  val w_wait_unit = Wire(Bool())
  val w_wait_mem = Wire(Bool())
  val w_wait = Wire(Bool())
  val w_res = Wire(UInt(p.nDataBit.W))

  w_wait := w_wait_unit | w_wait_mem

  // ******************************
  //         INTEGER UNIT
  // ******************************
  val m_alu = Module(new Alu(p))
  val m_bru = Module(new Bru(p))

  w_wait_unit := false.B
  w_res := DontCare

  // ------------------------------
  //              ALU
  // ------------------------------
  m_alu.io.b_in.valid := io.b_in.valid & (io.b_in.ctrl.get.int.unit === INTUNIT.ALU)
  m_alu.io.b_in.ctrl.get.uop := io.b_in.ctrl.get.int.uop
  m_alu.io.b_in.ctrl.get.pc := io.b_in.ctrl.get.info.pc
  m_alu.io.b_in.ctrl.get.ssign := io.b_in.ctrl.get.int.ssign
  m_alu.io.b_in.data.get.s1 := io.b_in.data.get.s1
  m_alu.io.b_in.data.get.s2 := io.b_in.data.get.s2
  m_alu.io.b_in.data.get.s3 := io.b_in.data.get.s3

  m_alu.io.b_out.ready := true.B

  when (io.b_in.ctrl.get.int.unit === INTUNIT.ALU) {
    w_wait_unit := false.B
    w_res := m_alu.io.b_out.data.get
  }

  // ------------------------------
  //              BRU
  // ------------------------------
  m_bru.io.b_in.valid := io.b_in.valid & (io.b_in.ctrl.get.int.unit === INTUNIT.BRU)
  m_bru.io.b_in.ctrl.get.uop := io.b_in.ctrl.get.int.uop
  m_bru.io.b_in.ctrl.get.pc := io.b_in.ctrl.get.info.pc
  m_bru.io.b_in.ctrl.get.ssign := io.b_in.ctrl.get.int.ssign
  m_bru.io.b_in.data.get.s1 := io.b_in.data.get.s1
  m_bru.io.b_in.data.get.s2 := io.b_in.data.get.s2
  m_bru.io.b_in.data.get.s3 := io.b_in.data.get.s3

  m_bru.io.i_br_next := io.i_br_next
  io.o_br_new := m_bru.io.o_br_new

  m_bru.io.b_out.ready := true.B

  when (io.b_in.ctrl.get.int.unit === INTUNIT.BRU) {
    w_wait_unit := ~m_bru.io.b_out.valid
    w_res := m_bru.io.b_out.data.get
  }


  // ******************************
  //         LOAD STORE UNIT
  // ******************************
  m_l0d.io.i_flush := false.B

  w_wait_mem := io.b_in.ctrl.get.lsu.use & ~m_l0d.io.b_lbus.ready

  m_l0d.io.b_lbus.valid := io.b_in.valid & io.b_in.ctrl.get.lsu.use
  m_l0d.io.b_lbus.ctrl.rw := io.b_in.ctrl.get.lsu.st
  m_l0d.io.b_lbus.ctrl.addr := m_alu.io.b_out.data.get
  m_l0d.io.b_lbus.wdata := io.b_in.data.get.s3

  m_l0d.io.b_lbus.ctrl.size := DontCare
  switch (io.b_in.ctrl.get.lsu.size) {
    is (LSUSIZE.B) {
      m_l0d.io.b_lbus.ctrl.size := SIZE.B1.U
    }
    is (LSUSIZE.H) {
      m_l0d.io.b_lbus.ctrl.size := SIZE.B2.U
    }
    is (LSUSIZE.W) {
      m_l0d.io.b_lbus.ctrl.size := SIZE.B4.U
    }
  }

  m_l0d.io.b_mbus <> io.b_dmem

  when (io.b_in.ctrl.get.lsu.use) {
    w_res := m_l0d.io.b_lbus.rdata
  }

  // ******************************
  //              GPR
  // ******************************
  // ------------------------------
  //             BYPASS
  // ------------------------------
  if (p.useIdStage) {
    io.o_byp.get.valid := io.b_in.valid & io.b_in.ctrl.get.gpr.en
    io.o_byp.get.ready := ~w_wait
    io.o_byp.get.addr := io.b_in.ctrl.get.gpr.addr
    io.o_byp.get.data := w_res
  }

  // ------------------------------
  //             WRITE
  // ------------------------------
  io.b_rd.valid := io.b_in.valid & io.b_in.ctrl.get.gpr.en & ~w_wait
  io.b_rd.addr := io.b_in.ctrl.get.gpr.addr
  io.b_rd.data := w_res

  // ******************************
  //             LOCK
  // ******************************
  io.b_in.ready := ~w_wait

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