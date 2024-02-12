/*
 * File: wb.scala                                                              *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-02-06 03:35:24 pm                                       *
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

    val o_byp = Output(new BypassBus(p))

    val b_pipe = new FpuAckIO(p, p.nDataBit)
    val b_rd = Flipped(new FprWriteIO(p))
  })  

  io.b_pipe := DontCare

  // ******************************
  //           NORMALIZE
  // ******************************
  val w_norm = Wire(new FloatBus(p.nExponentBit, p.nMantissaBit))
  val w_zero = Wire(Bool())
  val w_high = Wire(UInt(p.nMantissaBit.W))
  val w_hzero = Wire(Bool())
  val w_hlone = Wire(UInt(log2Ceil(p.nMantissaBit).W))
  val w_low = Wire(UInt(p.nMantissaBit.W))
  val w_lzero = Wire(Bool())
  val w_llone = Wire(UInt(log2Ceil(p.nMantissaBit).W))

  w_zero := ~io.b_in.data.get.res.mant.orR
  w_high := io.b_in.data.get.res.mant(p.nMantissaBit * 2 - 1, p.nMantissaBit)
  w_hzero := ~w_high.orR
  w_hlone := PriorityEncoder(Reverse(w_high))
  w_low := io.b_in.data.get.res.mant(p.nMantissaBit - 1, 0)
  w_lzero := ~w_low.orR
  w_llone := PriorityEncoder(Reverse(w_low))

  w_norm := io.b_in.data.get.res
  when (~w_hzero) {
    w_norm.expo := io.b_in.data.get.res.expo + ((p.nMantissaBit - 1).U - w_hlone)
    w_norm.mant := (io.b_in.data.get.res.mant >> ((p.nMantissaBit - 1).U - w_hlone))
  }.otherwise {
    w_norm.expo := io.b_in.data.get.res.expo - (w_llone + 1.U)
    w_norm.mant := (io.b_in.data.get.res.mant << (w_llone + 1.U))
  }

  // ******************************
  //              FPR
  // ******************************
  io.b_rd.valid := io.b_in.valid & io.b_in.ctrl.get.fpr.en & io.b_pipe.ready
  io.b_rd.addr := io.b_in.ctrl.get.fpr.addr
  io.b_rd.data := w_norm

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
  io.b_in.ready := io.b_pipe.ready

  io.b_pipe.valid := io.b_in.valid & io.b_in.ctrl.get.info.int
  when (io.b_in.ctrl.get.info.int) {
    io.b_pipe.data.get := io.b_in.data.get.res.toUInt()
  }.otherwise {
    io.b_pipe.data.get := w_norm.toUInt()
  }

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