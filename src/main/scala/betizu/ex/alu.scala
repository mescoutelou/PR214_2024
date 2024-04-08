/*
 * File: alu.scala                                                             *
 * Created Date: 2023-02-25 10:19:59 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-08 12:01:46 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.betizu

import chisel3._
import chisel3.util._

import prj.common.gen._


class Alu (p: BetizuParams) extends Module {
  import prj.betizu.INTUOP._

  val io = IO(new Bundle {
    val b_in = Flipped(new GenRVIO(p, new IntUnitReqCtrlBus(p), new IntUnitReqDataBus(p)))
    val b_out = new GenRVIO(p, UInt(0.W), UInt(p.nDataBit.W))
  })  

  // ******************************
  //           OPERANDS
  // ******************************
  val w_uop = Wire(UInt(NBIT.W))
  val w_sign = Wire(Bool())
  val w_s1 = Wire(UInt(p.nDataBit.W))
  val w_s2 = Wire(UInt(p.nDataBit.W))
  val w_amount = Wire(UInt(log2Ceil(p.nDataBit).W))

  w_amount := io.b_in.data.get.s2(4,0).asUInt
  w_sign := io.b_in.ctrl.get.ssign(0) | io.b_in.ctrl.get.ssign(1)
  w_uop := io.b_in.ctrl.get.uop
  w_s1 := io.b_in.data.get.s1
  w_s2 := io.b_in.data.get.s2

  // ******************************
  //            LOGIC
  // ******************************
  val w_res = Wire(UInt(p.nDataBit.W))

  w_res := 0.U  
  switch (w_uop) {
    is (ADD) {
      w_res := w_s1 + w_s2
    }
    is (SUB) {
      w_res := w_s1 - w_s2
    }
    is (SLT) {
      when (w_sign) {
        w_res := (w_s1).asSInt < (w_s2).asSInt
      }.otherwise {
        w_res := w_s1 < w_s2
      }      
    }
    is (OR) {
      w_res := w_s1 | w_s2
    }
    is (AND) {
      w_res := w_s1 & w_s2
    }
    is (XOR) {
      w_res := w_s1 ^ w_s2
    }
    is (SHR) {
      when (w_sign) {
        w_res := ((w_s1).asSInt >> w_amount).asUInt
      }.otherwise {
        w_res := w_s1 >> w_amount
      }      
    }
    is (SHL) {
      w_res := w_s1 << w_amount      
    }
  }

  // ******************************
  //             OUTPUT
  // ******************************  
  io.b_in.ready := true.B
  
  io.b_out.valid := io.b_in.valid
  io.b_out.data.get := w_res

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    // ------------------------------
    //            SIGNALS
    // ------------------------------
    dontTouch(io.b_in)
    dontTouch(io.b_out)
  }
}

object Alu extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Alu(BetizuConfigBase),
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
