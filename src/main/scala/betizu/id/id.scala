/*
 * File: id.scala                                                              *
 * Created Date: 2023-02-25 10:19:59 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-08 02:13:37 pm                                       *
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
import prj.common.isa.base._


class IdStage(p: BetizuParams) extends Module {
  val io = IO(new Bundle {    
    val i_flush = Input(Bool())

    val b_in = Flipped(new GenRVIO(p, new FetchBus(p), UInt(0.W)))

    val o_br_next = Output(new BranchBus(p))
    val b_rs = Vec(2, Flipped(new GprReadIO(p)))

    val b_out = new GenRVIO(p, new ExCtrlBus(p), new DataBus(p))
  })  

  val m_out = if (p.useIdStage) Some(Module(new GenReg(p, new ExCtrlBus(p), new DataBus(p), true))) else None
    
  val w_flush = Wire(Bool())
  val w_lock = Wire(Bool())
  val w_wait = Wire(Bool())

  // ******************************
  //             STATUS            
  // ******************************
  w_flush := io.i_flush

  // ******************************
  //            DECODER
  // ******************************
  val m_decoder = Module(new Decoder(p))
  
  m_decoder.io.i_instr := io.b_in.ctrl.get.instr

  // ******************************
  //              GPR
  // ******************************
  io.b_rs(0).valid := true.B
  io.b_rs(0).addr := m_decoder.io.o_data.rs1

  io.b_rs(1).valid := true.B
  io.b_rs(1).addr := m_decoder.io.o_data.rs2

  // ******************************
  //             IMM
  // ******************************
  val m_imm1 = Module(new SlctImm(p))

  m_imm1.io.i_instr := io.b_in.ctrl.get.instr
  m_imm1.io.i_imm_type := m_decoder.io.o_data.imm1type

  val m_imm2 = Module(new SlctImm(p))

  m_imm2.io.i_instr := io.b_in.ctrl.get.instr
  m_imm2.io.i_imm_type := m_decoder.io.o_data.imm2type

  // ******************************
  //             SOURCE
  // ******************************
  // ------------------------------
  //               S1
  // ------------------------------
  val m_s1_src = Module(new SlctSource(p))

  m_s1_src.io.i_src_type := m_decoder.io.o_data.s1type
  m_s1_src.io.i_rs := io.b_rs(0).data
  m_s1_src.io.i_imm1 := m_imm1.io.o_val
  m_s1_src.io.i_imm2 := m_imm2.io.o_val
  m_s1_src.io.i_pc := io.b_in.ctrl.get.pc
  m_s1_src.io.i_instr := io.b_in.ctrl.get.instr

  // ------------------------------
  //               S2
  // ------------------------------
  val m_s2_src = Module(new SlctSource(p))

  m_s2_src.io.i_src_type := m_decoder.io.o_data.s2type
  m_s2_src.io.i_rs := io.b_rs(1).data
  m_s2_src.io.i_imm1 := m_imm1.io.o_val
  m_s2_src.io.i_imm2 := m_imm2.io.o_val
  m_s2_src.io.i_pc := io.b_in.ctrl.get.pc
  m_s2_src.io.i_instr := io.b_in.ctrl.get.instr

  // ------------------------------
  //               S3
  // ------------------------------
  val m_s3_src = Module(new SlctSource(p))

  m_s3_src.io.i_src_type := m_decoder.io.o_data.s3type
  m_s3_src.io.i_rs := io.b_rs(1).data
  m_s3_src.io.i_imm1 := m_imm1.io.o_val
  m_s3_src.io.i_imm2 := m_imm2.io.o_val
  m_s3_src.io.i_pc := io.b_in.ctrl.get.pc
  m_s3_src.io.i_instr := io.b_in.ctrl.get.instr

  // ******************************
  //          DEPENDENCIES
  // ******************************
  val w_wait_rs = Wire(Bool())
  
  when (io.b_in.valid & (m_decoder.io.o_data.s1type === OP.XREG) & ~io.b_rs(0).ready) {
    w_wait_rs := true.B
  }.elsewhen (io.b_in.valid & (m_decoder.io.o_data.s2type === OP.XREG) & ~io.b_rs(1).ready) {
    w_wait_rs := true.B
  }.elsewhen (io.b_in.valid & (m_decoder.io.o_data.s3type === OP.XREG) & ~io.b_rs(1).ready) {
    w_wait_rs := true.B
  }.otherwise {
    w_wait_rs := false.B
  }

  // ******************************
  //            OUTPUT
  // ******************************
  w_wait := w_wait_rs

  // ------------------------------
  //            REGISTER
  // ------------------------------
  if (p.useIdStage) {
    w_lock := ~m_out.get.io.b_in.ready

    m_out.get.io.b_in.valid := io.b_in.valid & ~w_flush & ~w_wait
    m_out.get.io.b_in.ctrl.get.info := m_decoder.io.o_info
    m_out.get.io.b_in.ctrl.get.info.pc := io.b_in.ctrl.get.pc
    m_out.get.io.b_in.ctrl.get.int := m_decoder.io.o_int
    m_out.get.io.b_in.ctrl.get.lsu := m_decoder.io.o_lsu
    m_out.get.io.b_in.ctrl.get.gpr := m_decoder.io.o_gpr
    m_out.get.io.b_in.ctrl.get.ext := m_decoder.io.o_ext

    m_out.get.io.b_in.data.get.s1 := m_s1_src.io.o_val
    m_out.get.io.b_in.data.get.s2 := m_s2_src.io.o_val
    m_out.get.io.b_in.data.get.s3 := m_s3_src.io.o_val  

    io.b_out <> m_out.get.io.b_out

  // ------------------------------
  //             DIRECT
  // ------------------------------
  } else {
    w_lock := ~io.b_out.ready

    io.b_out.valid := io.b_in.valid & ~w_flush & ~w_wait
    io.b_out.ctrl.get.info := m_decoder.io.o_info
    io.b_out.ctrl.get.info.pc := io.b_in.ctrl.get.pc
    io.b_out.ctrl.get.int := m_decoder.io.o_int
    io.b_out.ctrl.get.lsu := m_decoder.io.o_lsu
    io.b_out.ctrl.get.gpr := m_decoder.io.o_gpr
    io.b_out.ctrl.get.ext := m_decoder.io.o_ext

    io.b_out.data.get.s1 := m_s1_src.io.o_val
    io.b_out.data.get.s2 := m_s2_src.io.o_val
    io.b_out.data.get.s3 := m_s3_src.io.o_val  
  }

  // ------------------------------
  //             LOCK
  // ------------------------------
  io.b_in.ready := w_flush | ~(w_wait | w_lock)

  // ******************************
  //          NEXT BRANCH
  // ******************************
  io.o_br_next.valid := io.b_in.valid
  io.o_br_next.addr := io.b_in.ctrl.get.pc

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    // ------------------------------
    //            SIGNALS
    // ------------------------------

  }
}

object IdStage extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new IdStage(BetizuConfigBase),
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