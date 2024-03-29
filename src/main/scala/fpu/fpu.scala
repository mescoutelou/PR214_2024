/*
 * File: fpu.scala                                                             *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 02:44:45 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.fpu

import chisel3._
import chisel3.util._

import prj.common.gen._
import prj.common.mbus._


class Fpu(p: FpuParams) extends Module {
  val io = IO(new Bundle {
    val b_pipe = new FpuIO(p, p.nDataBit)

    val b_mem = new MBusIO(p.pDBus)

	  val o_sim = if (p.isSim) Some(Output(Vec(32, UInt(32.W)))) else None
  })  

  val m_rr = Module(new RrStage(p))
  val m_shift = Module(new ShiftStage(p))
  val m_ex = Module(new ExStage(p))
  val m_wb = Module(new WbStage(p))
  val m_fpr = Module(new Fpr(p))

  m_rr.io.b_pipe <> io.b_pipe.req
  m_rr.io.b_rs <> m_fpr.io.b_read

  m_shift.io.b_in <> m_rr.io.b_out

  m_ex.io.b_in <> m_shift.io.b_out

  m_wb.io.b_in <> m_ex.io.b_out
  m_wb.io.b_pipe <> io.b_pipe.ack

  var v_nbyp: Int = 0
  m_fpr.io.i_byp(v_nbyp) := m_wb.io.o_byp
  v_nbyp = v_nbyp + 1
  if (p.useExStage) {
    m_fpr.io.i_byp(v_nbyp) := m_ex.io.o_byp
    v_nbyp = v_nbyp + 1
  }
  if (p.useShiftStage) {
    m_fpr.io.i_byp(v_nbyp) := m_shift.io.o_byp
    v_nbyp = v_nbyp + 1
  }
  
  m_fpr.io.b_write <> m_wb.io.b_rd

  io.b_mem := DontCare

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    io.o_sim.get := m_fpr.io.o_sim.get
  }  
}

object Fpu extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Fpu(FpuConfigBase),
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