/*
 * File: shift.scala                                                           *
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


class WbStage(p: FpuParams) extends Module {
  val io = IO(new Bundle {
    val b_in = Flipped(new GenRVIO(p, new WbCtrlBus(p), new ResultBus(p)))

    val b_pipe = new FpuAckIO(p, p.nDataBit)
    val b_rd = Flipped(new FprWriteIO(p))
  })  

  io.b_in := DontCare
  io.b_pipe := DontCare
  io.b_rd := DontCare

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {

  }  
}

object WbStage extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new WbStage(FpuConfigBase),
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