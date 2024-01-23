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

import prj.common.mbus._


class Fpu(p: FpuParams) extends Module {
  val io = IO(new Bundle {
    val b_mem = new MBusIO(p.pDBus)

	  val o_sim = if (p.isSim) Some(Output(Vec(32, UInt(32.W)))) else None
  })  

  val m_fpr = Module(new Fpr(p))

  io.b_mem := DontCare
  m_fpr.io := DontCare

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