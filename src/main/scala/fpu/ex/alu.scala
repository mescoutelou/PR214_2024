/*
 * File: alu.scala                                                             *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-16 09:41:13 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 HerdWare                                                 *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.fpu

import chisel3._
import chisel3.util._

import emmk.common.gen._
import emmk.common.mbus._


class Alu(p: FpuParams) extends Module {
  val io = IO(new Bundle {
    val b_req = Flipped(new GenRVIO(p, new ExBus(p), new OperandBus(p)))

    val b_ack = new GenRVIO(p, UInt(0.W), new FloatBus(p.nExponentBit, p.nMantissaBit * 2))
  })  

  val w_src = Wire(Vec(3, new FloatBus(p.nExponentBit, p.nMantissaBit * 2)))
  val w_res = Wire(new FloatBus(p.nExponentBit, p.nMantissaBit * 2))

  val w_snan = Wire(Vec(3, Bool()))
  val w_cnan = Wire(Vec(3, Bool()))
  val w_nan = Wire(Vec(3, Bool()))
  val w_pinf = Wire(Vec(3, Bool()))
  val w_ninf = Wire(Vec(3, Bool()))

  for (s <- 0 until 3) {
    w_src(s).sign := io.b_req.data.get.src(s).sign
    w_src(s).expo := io.b_req.data.get.src(s).expo
//    w_src(s).mant := io.b_req.data.get.src(s).mant
    w_src(s).mant := Cat(Fill(p.nMantissaBit - 1, io.b_req.data.get.neg(s)), io.b_req.data.get.src(s).mant)

    w_snan(s) := io.b_req.data.get.src(s).issNaN()
    w_cnan(s) := io.b_req.data.get.src(s).iscNaN()
    w_nan(s) := io.b_req.data.get.src(s).isNaN()
    w_pinf(s) := io.b_req.data.get.src(s).ispInf()
    w_ninf(s) := io.b_req.data.get.src(s).isnInf()
  }

  // ******************************
  //              ALU
  // ******************************
  w_res := DontCare

  switch (io.b_req.ctrl.get.uop) {
    is (UOP.MV) {
      w_res := w_src(0)
    }
    is (UOP.ADD) {
      val w_add = Wire(UInt((p.nMantissaBit * 2).W))

      w_add := w_src(0).mant + w_src(1).mant

      when (io.b_req.data.get.agreat) {
        w_res.sign := w_src(0).sign
      }.otherwise {
        w_res.sign := w_src(1).sign
      }
      w_res.expo := w_src(0).expo
      w_res.mant := w_add

      when (w_nan(0) | w_nan(1)) {
        w_res := NAN.CNAN(p.nExponentBit, p.nMantissaBit * 2)
      }.elsewhen (w_pinf(0) | w_pinf(1)) {
        w_res := NAN.PINF(p.nExponentBit, p.nMantissaBit * 2)
      }.elsewhen (w_ninf(0) | w_ninf(1)) {
        w_res := NAN.NINF(p.nExponentBit, p.nMantissaBit * 2)
      }.elsewhen ((io.b_req.data.get.neg(0) ^ io.b_req.data.get.neg(1)) & (w_add === 0.U)) {
        w_res := NAN.PZERO(p.nExponentBit, p.nMantissaBit * 2)
      }
    }
    is (UOP.MIN) {
      when (io.b_req.data.get.sgreat) {
        w_res := w_src(1)
      }.otherwise {
        w_res := w_src(0)
      }
    }
    is (UOP.MAX) {
      when (io.b_req.data.get.sgreat) {
        w_res := w_src(0)
      }.otherwise {
        w_res := w_src(1)
      }
    }
    is (UOP.EQ) {
      when (io.b_req.data.get.equ.asUInt.andR) {
        w_res := 1.U.asTypeOf(w_res)
      }.otherwise {
        w_res := 0.U.asTypeOf(w_res)
      }
    }
    is (UOP.LT) {
      when (~io.b_req.data.get.sgreat & ~io.b_req.data.get.equ.asUInt.andR) {
        w_res := 1.U.asTypeOf(w_res)
      }.otherwise {
        w_res := 0.U.asTypeOf(w_res)
      }
    }
    is (UOP.LE) {
      when (~io.b_req.data.get.sgreat | io.b_req.data.get.equ.asUInt.andR) {
        w_res := 1.U.asTypeOf(w_res)
      }.otherwise {
        w_res := 0.U.asTypeOf(w_res)
      }
    }
    is (UOP.CLASS) {
      val w_bit = Wire(Vec(10, Bool()))
      
      w_bit(0) := (io.b_req.data.get.src(0) === NAN.NINF(p.nExponentBit, p.nMantissaBit + 1))
      w_bit(1) := io.b_req.data.get.src(0).sign
      w_bit(2) := false.B
      w_bit(3) := (io.b_req.data.get.src(0) === NAN.NZERO(p.nExponentBit, p.nMantissaBit + 1))
      w_bit(4) := (io.b_req.data.get.src(0) === NAN.PZERO(p.nExponentBit, p.nMantissaBit + 1))
      w_bit(5) := false.B
      w_bit(6) := ~io.b_req.data.get.src(0).sign
      w_bit(7) := (io.b_req.data.get.src(0) === NAN.PINF(p.nExponentBit, p.nMantissaBit + 1))
      w_bit(8) := (io.b_req.data.get.src(0) === NAN.SNAN(p.nExponentBit, p.nMantissaBit + 1))
      w_bit(9) := (io.b_req.data.get.src(0) === NAN.QNAN(p.nExponentBit, p.nMantissaBit + 1))

      w_res := w_bit.asUInt.asTypeOf(w_res) 
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