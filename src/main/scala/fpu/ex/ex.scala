/*
 * File: ex.scala                                                              *
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


class ExStage(p: FpuParams) extends Module {
  val io = IO(new Bundle {
    val b_in = Flipped(new GenRVIO(p, new ExCtrlBus(p), new DataBus(p)))

    val b_out = new GenRVIO(p, new WbCtrlBus(p), new ResultBus(p))
  })  

  val m_reg = if (p.useExStage) Some(Module(new GenReg(p, new WbCtrlBus(p), new ResultBus(p), true))) else None

  // ******************************
  //             OUTPUT
  // ******************************
  if (p.useExStage) {
    io.b_in.ready := m_reg.get.io.b_in.ready

    m_reg.get.io.b_in.valid := io.b_in.valid
    m_reg.get.io.b_in.ctrl.get.info := io.b_in.ctrl.get.info
    m_reg.get.io.b_in.ctrl.get.fpr := io.b_in.ctrl.get.fpr
    m_reg.get.io.b_in.data.get.res := DontCare

    io.b_out <> m_reg.get.io.b_out 
  } else {
    io.b_in.ready := io.b_out.ready

    io.b_out.valid := io.b_in.valid
    io.b_out.ctrl.get.info := io.b_in.ctrl.get.info
    io.b_out.ctrl.get.fpr := io.b_in.ctrl.get.fpr
    io.b_out.data.get.res := DontCare
  }

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {

  }  
}

object ExStage extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new ExStage(FpuConfigBase),
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