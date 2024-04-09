/*
 * File: sys.scala                                                             *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-09 11:01:49 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.sys

import chisel3._
import chisel3.util._

import prj.common.mbus._
import prj.common.ram._
import prj.betizu._
import prj.fpu._

class Sys(p: SysParams) extends Module {
  val io = IO(new Bundle {
    val o_sim = if (p.isSim) Some(Output(new SysSimBus(p))) else None
  })  

  val m_betizu = Module(new Betizu(p.pBetizu))
  val m_fpu = if (p.useFpu) Some(Module(new Fpu(p.pFpu))) else None
  val m_cross = Module(new MBusCrossbar(p.pBusCross))
  val m_rom = Module(new MBusRam(p.pRom))
  val m_ram = Module(new MBusRam(p.pRam))

  if (p.useFpu) m_betizu.io.b_fpu.get <> m_fpu.get.io.b_pipe

  m_cross.io.b_m(0) <> m_betizu.io.b_dmem
  m_cross.io.b_m(1) <> m_betizu.io.b_imem
  if (p.useFpu) m_cross.io.b_m(2) <> m_fpu.get.io.b_mem
  m_cross.io.b_s(0) <> m_rom.io.b_port(0)
  m_cross.io.b_s(1) <> m_ram.io.b_port(0)  

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    io.o_sim.get.gpr := m_betizu.io.o_sim.get
    if (p.useFpu) io.o_sim.get.fpr.get := m_fpu.get.io.o_sim.get
  }  
}

object Sys extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Sys(SysConfigBase),
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