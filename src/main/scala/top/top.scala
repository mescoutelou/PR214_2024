/*
 * File: top.scala                                                             *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 02:44:55 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.top

import chisel3._
import chisel3.util._

import prj.common.mbus._
import prj.common.ram._
import prj.core._
import prj.fpu._

class Top(p: TopParams) extends Module {
  val io = IO(new Bundle {
    val o_sim = if (p.isSim) Some(Output(new TopSimBus())) else None
  })  

  val m_core = Module(new Core(p.pCore))
  val m_fpu = Module(new Fpu(p.pFpu))
  val m_cross = Module(new MBusCrossbar(p.pBusCross))
  val m_imem = Module(new MBusRam(p.pIMem))
  val m_dmem = Module(new MBusRam(p.pDMem))

  m_core.io := DontCare
  m_fpu.io := DontCare

  m_cross.io.b_m(0) <> m_core.io.b_dmem
  m_cross.io.b_m(1) <> m_core.io.b_imem
  m_cross.io.b_m(2) <> m_fpu.io.b_mem
  m_cross.io.b_s(0) <> m_imem.io.b_port(0)
  m_cross.io.b_s(1) <> m_dmem.io.b_port(0)  

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    io.o_sim.get.gpr := m_core.io.o_sim.get
    io.o_sim.get.fpr := m_fpu.io.o_sim.get
  }  
}

object Top extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Top(TopConfigBase),
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