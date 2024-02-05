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


class ShiftStage(p: FpuParams) extends Module {
  val io = IO(new Bundle {
    val b_in = Flipped(new GenRVIO(p, new ShiftCtrlBus(p), new DataBus(p)))

    val o_byp = Output(new BypassBus(p))

    val b_out = new GenRVIO(p, new ExCtrlBus(p), new DataBus(p))
  })  

  val m_reg = if (p.useShiftStage) Some(Module(new GenReg(p, new ExCtrlBus(p), new DataBus(p), true))) else None

  val w_src = Wire(Vec(3, new FloatBus(p)))

  // ******************************
  //             SHIFT
  // ******************************
  val w_expo_diff = Wire(Vec(3, UInt(p.nExponentBit.W)))

  // Default
  for (s <- 0 until 3) {
    w_expo_diff(s) := 0.U
  }

  // Exponent difference
  switch (io.b_in.ctrl.get.ex.uop) {
    is (UOP.ADD) {
      when (io.b_in.data.get.src(1).exponent > io.b_in.data.get.src(0).exponent) {
        w_expo_diff(0) := (io.b_in.data.get.src(1).exponent - io.b_in.data.get.src(0).exponent)
        w_expo_diff(1) := 0.U
      }.otherwise {
        w_expo_diff(0) := 0.U
        w_expo_diff(1) := (io.b_in.data.get.src(0).exponent - io.b_in.data.get.src(1).exponent)
      }
    }
  }

  // Shift / Sub
  for (s <- 0 until 3) {
    w_src(s).sign := io.b_in.data.get.src(s).sign
    w_src(s).exponent := (io.b_in.data.get.src(s).exponent - w_expo_diff(s))
    w_src(s).mantissa := (io.b_in.data.get.src(s).mantissa >> w_expo_diff(s))
  }

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
  if (p.useShiftStage) {
    io.b_in.ready := m_reg.get.io.b_in.ready

    m_reg.get.io.b_in.valid := io.b_in.valid
    m_reg.get.io.b_in.ctrl.get := io.b_in.ctrl.get
    m_reg.get.io.b_in.data.get.src := w_src

    io.b_out <> m_reg.get.io.b_out 
  } else {
    io.b_in.ready := io.b_out.ready

    io.b_out.valid := io.b_in.valid
    io.b_out.ctrl.get := io.b_in.ctrl.get
    io.b_out.data.get.src := w_src
  }

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {

  }  
}

object ShiftStage extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new ShiftStage(FpuConfigBase),
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