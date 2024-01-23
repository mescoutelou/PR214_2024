/*
 * File: core.scala                                                            *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 02:45:01 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.core

import chisel3._
import chisel3.util._

import prj.common.mbus._


class Core(p: CoreParams) extends Module {
  val io = IO(new Bundle {
    val b_imem = new MBusIO(p.pIBus)
    val b_dmem = new MBusIO(p.pDBus)

	  val o_sim = if (p.isSim) Some(Output(Vec(32, UInt(32.W)))) else None
  })  

  io.b_imem := DontCare
  io.b_dmem := DontCare

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    io.o_sim.get := DontCare
    dontTouch(io.o_sim.get)
  }  
}

object Core extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Core(CoreConfigBase),
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