/*
 * File: ex.scala                                                              *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-02-06 01:49:55 pm                                       *
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
    val b_in = Flipped(new GenRVIO(p, new ExCtrlBus(p), new OperandBus(p)))

    val o_byp = Output(new BypassBus(p))

    val b_out = new GenRVIO(p, new WbCtrlBus(p), new ResultBus(p))
  })  

  val m_alu = Module(new Alu(p))
  val m_reg = if (p.useExStage) Some(Module(new GenReg(p, new WbCtrlBus(p), new ResultBus(p), true))) else None

  val w_res = Wire(new FloatBus(p.nExponentBit, p.nMantissaBit * 2))

  // ******************************
  //              ALU
  // ******************************
  m_alu.io.b_req.valid := io.b_in.valid
  m_alu.io.b_req.ctrl.get := io.b_in.ctrl.get.ex
  m_alu.io.b_req.data.get := io.b_in.data.get

  w_res := m_alu.io.b_ack.data.get
  m_alu.io.b_ack.ready := true.B

  // ******************************
  //             BYPASS
  // ******************************
  io.o_byp.valid := io.b_in.valid & io.b_in.ctrl.get.fpr.en
  io.o_byp.ready := false.B
  io.o_byp.addr := io.b_in.ctrl.get.fpr.addr
  io.o_byp.data := DontCare

  // ******************************
  //             OUTPUT
  // ******************************
  if (p.useExStage) {
    io.b_in.ready := m_reg.get.io.b_in.ready

    m_reg.get.io.b_in.valid := io.b_in.valid
    m_reg.get.io.b_in.ctrl.get.info := io.b_in.ctrl.get.info
    m_reg.get.io.b_in.ctrl.get.fpr := io.b_in.ctrl.get.fpr
    m_reg.get.io.b_in.data.get.res := w_res

    io.b_out <> m_reg.get.io.b_out 
  } else {
    io.b_in.ready := io.b_out.ready

    io.b_out.valid := io.b_in.valid
    io.b_out.ctrl.get.info := io.b_in.ctrl.get.info
    io.b_out.ctrl.get.fpr := io.b_in.ctrl.get.fpr
    io.b_out.data.get.res := w_res
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