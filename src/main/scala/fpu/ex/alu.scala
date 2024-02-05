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


class Alu(p: FpuParams) extends Module {
  val io = IO(new Bundle {
    val b_req = Flipped(new GenRVIO(p, UInt(UOP.NBIT.W), new DataBus(p)))

    val b_ack = new GenRVIO(p, UInt(0.W), new FloatBus(p))
  })  

  val w_src = Wire(Vec(3, new FloatBus(p)))
  val w_res = Wire(new FloatBus(p))

  for (s <- 0 until 3) {
    w_src(s) := io.b_req.data.get.src(s)
  }

  // ******************************
  //              ALU
  // ******************************
  w_res := NAN.PZERO(p)

  switch (io.b_req.ctrl.get) {
    is (UOP.MV) {
      w_res := w_src(0)
    }
    is (UOP.ADD) {
      when ((w_src(0).exponent > w_src(1).exponent) | ((w_src(0).exponent === w_src(1).exponent) & (w_src(0).mantissa > w_src(1).mantissa))) {
        w_res.sign := w_src(0).sign
      }.otherwise {
        w_res.sign := w_src(1).sign
      }
      w_res.exponent := w_src(0).exponent
      w_res.mantissa := w_src(0).mantissa + w_src(1).mantissa
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