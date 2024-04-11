/*
 * File: wb.scala                                                              *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-11 10:10:34 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.fpu

import chisel3._
import chisel3.util._

import emmk.common.gen._
import emmk.common.mbus._


class WbStage(p: FpuParams) extends Module {
  val io = IO(new Bundle {
    val b_in = Flipped(new GenRVIO(p, new WbCtrlBus(p), new ResultBus(p)))

    val b_mem = new MBusAckIO(p.pDBus)
    val o_byp = Output(new BypassBus(p))

    val b_pipe = new FpuAckIO(p, p.nDataBit)
    val b_rd = Flipped(new FprWriteIO(p))
  })  

  val w_wait_mem = Wire(Bool())
  val w_res = Wire(new FloatBus(p.nExponentBit, p.nMantissaBit))

  // ******************************
  //           NORMALIZE
  // ******************************
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

  w_res := io.b_in.data.get.res
  when (~w_hzero) {
    w_res.expo := io.b_in.data.get.res.expo + ((p.nMantissaBit - 1).U - w_hlone)
    w_res.mant := (io.b_in.data.get.res.mant >> ((p.nMantissaBit - 1).U - w_hlone))
  }.otherwise {
    w_res.expo := io.b_in.data.get.res.expo - (w_llone + 1.U)
    w_res.mant := (io.b_in.data.get.res.mant << (w_llone + 1.U))
  }

  // ******************************
  //     MEMORY ACKNOWLEDGEMENT
  // ******************************
  w_wait_mem := io.b_in.valid & ((io.b_in.ctrl.get.ld() & ~io.b_mem.read.valid) | (io.b_in.ctrl.get.st() & ~io.b_mem.write.ready))

  io.b_mem.read.ready := io.b_in.valid & io.b_in.ctrl.get.ld() & io.b_pipe.ready

  io.b_mem.write.valid := io.b_in.valid & io.b_in.ctrl.get.st() & io.b_pipe.ready
  io.b_mem.write.data := Cat(io.b_in.data.get.res.sign, io.b_in.data.get.res.expo, io.b_in.data.get.res.mant(22, 0))

  when (io.b_in.ctrl.get.ld()) {
    w_res.fromUInt(io.b_mem.read.data)
  }

  // ******************************
  //              FPR
  // ******************************
  io.b_rd.valid := io.b_in.valid & io.b_in.ctrl.get.fpr.en & io.b_pipe.ready & ~w_wait_mem
  io.b_rd.addr := io.b_in.ctrl.get.fpr.addr
  io.b_rd.data := w_res

  // ******************************
  //             BYPASS
  // ******************************
  io.o_byp.valid := io.b_in.valid & io.b_in.ctrl.get.fpr.en
  io.o_byp.ready := ~w_wait_mem
  io.o_byp.addr := io.b_in.ctrl.get.fpr.addr
  io.o_byp.data := w_res

  // ******************************
  //             OUTPUT
  // ******************************
  io.b_in.ready := io.b_pipe.ready & ~w_wait_mem

  io.b_pipe.valid := io.b_in.valid & ~w_wait_mem
  when (io.b_in.ctrl.get.info.int) {
    io.b_pipe.data.get := io.b_in.data.get.res.toUInt()
  }.otherwise {
    io.b_pipe.data.get := w_res.toUInt()
  }

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    dontTouch(io.b_in)
    dontTouch(io.b_mem)
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