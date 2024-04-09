/*
 * File: betizu.scala                                                          *
 * Created Date: 2023-02-25 10:19:59 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-09 10:38:52 am                                       *
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
import prj.fpu.{FpuIO}



class Betizu(p: BetizuParams) extends Module {
  val io = IO(new Bundle {    
    val b_imem = new MBusIO(p.pL0IBus)

    val b_fpu = if (p.useFpu) Some(Flipped(new FpuIO(p, p.nDataBit))) else None
    val b_dmem = new MBusIO(p.pL0DBus)

    val o_sim = if (p.isSim) Some(Output(Vec(32, UInt(p.nDataBit.W)))) else None  
  })  

  val m_if = Module(new IfStage(p))
  val m_id = Module(new IdStage(p))
  val m_ex = Module(new ExStage(p))
  val m_gpr = Module(new Gpr(p))

  // ******************************
  //            IF STAGE
  // ******************************
  m_if.io.i_br_new := m_ex.io.o_br_new
  m_if.io.b_imem <> io.b_imem

  // ******************************
  //            ID STAGE
  // ******************************
  if (p.useIdStage) {
    m_id.io.i_flush := m_ex.io.o_br_new.valid
  } else {
    m_id.io.i_flush := false.B
  }
  m_id.io.b_in <> m_if.io.b_out
  m_id.io.b_rs <> m_gpr.io.b_read

  // ******************************
  //            EX STAGE
  // ******************************
  m_ex.io.b_in <> m_id.io.b_out
  if (p.useIdStage) {
    m_ex.io.i_br_next := m_id.io.o_br_next
  } else if (p.useIfStage) {
    m_ex.io.i_br_next := m_if.io.o_br_next
  } else {
    m_ex.io.i_br_next := DontCare
    m_ex.io.i_br_next.valid := false.B
  }
  if (p.useFpu) m_ex.io.b_fpu.get <> io.b_fpu.get
  m_ex.io.b_dmem <> io.b_dmem

  // ******************************
  //              GPR
  // ******************************
  m_gpr.io.i_byp := m_ex.io.o_byp
  m_gpr.io.b_write <> m_ex.io.b_rd

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    // ------------------------------
    //            SIGNALS
    // ------------------------------
    io.o_sim.get := m_gpr.io.o_sim.get
  }
}

object Betizu extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Betizu(BetizuConfigBase),
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