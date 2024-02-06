/*
 * File: alu.scala                                                             *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-02-06 03:46:24 pm                                       *
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


class Alu(p: FpuParams) extends Module {
  val io = IO(new Bundle {
    val b_req = Flipped(new GenRVIO(p, new ExBus(p), new OperandBus(p)))

    val b_ack = new GenRVIO(p, UInt(0.W), new FloatBus(p.nExponentBit, p.nMantissaBit * 2))
  })  

  val w_src = Wire(Vec(3, new FloatBus(p.nExponentBit, p.nMantissaBit * 2)))
  val w_res = Wire(new FloatBus(p.nExponentBit, p.nMantissaBit * 2))

  for (s <- 0 until 3) {
    w_src(s).sign := io.b_req.data.get.src(s).sign
    w_src(s).expo := io.b_req.data.get.src(s).expo
    w_src(s).mant := Cat(Fill(p.nMantissaBit - 1, io.b_req.ctrl.get.neg(s)), io.b_req.data.get.src(s).mant)
  }

  // ******************************
  //              ALU
  // ******************************
  w_res := NAN.PZERO(p.nExponentBit, p.nMantissaBit * 2)

  switch (io.b_req.ctrl.get.uop) {
    is (UOP.MV) {
      w_res := w_src(0)
    }
    is (UOP.ADD) {
      when (io.b_req.ctrl.get.agreat) {
        w_res.sign := w_src(0).sign
      }.otherwise {
        w_res.sign := w_src(1).sign
      }
      w_res.expo := w_src(0).expo
      w_res.mant := w_src(0).mant + w_src(1).mant
    }
    is (UOP.MIN) {
      when (io.b_req.ctrl.get.sgreat) {
        w_res := w_src(1)
      }.otherwise {
        w_res := w_src(0)
      }
    }
    is (UOP.MAX) {
      when (io.b_req.ctrl.get.sgreat) {
        w_res := w_src(0)
      }.otherwise {
        w_res := w_src(1)
      }
    }
  }

  // ******************************
  //             OUTPUT
  // ******************************
  io.b_req.ready := io.b_ack.ready
  io.b_ack.valid := io.b_req.valid
  io.b_ack.data.get := w_res

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {

  }  
}

object Alu extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Alu(FpuConfigBase),
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