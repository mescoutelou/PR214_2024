/*
 * File: shift.scala                                                           *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-16 11:49:20 am                                       *
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


class ShiftStage(p: FpuParams) extends Module {
  val io = IO(new Bundle {
    val b_in = Flipped(new GenRVIO(p, new ShiftCtrlBus(p), new SourceBus(p)))

    val o_byp = Output(new BypassBus(p))

    val b_out = new GenRVIO(p, new ExCtrlBus(p), new OperandBus(p))
  })  

  val m_reg = if (p.useShiftStage) Some(Module(new GenReg(p, new ExCtrlBus(p), new OperandBus(p), true))) else None

  val w_src = Wire(Vec(3, new FloatBus(p.nExponentBit, p.nMantissaBit + 1)))
  val w_uop = Wire(UInt(UOP.NBIT.W))
  val w_addr = Wire(UInt(p.nAddrBit.W))
  val w_sign_same = Wire(Bool())
	val w_equ = Wire(Vec(3, Bool()))
	val w_agreat = Wire(Bool())       // Absolute greatest
	val w_sgreat = Wire(Bool())       // Signed greatest
	val w_neg = Wire(Vec(3, Bool()))
	val w_inf = Wire(Vec(3, Bool()))

  // ******************************
  //            COMPARE
  // ******************************
  w_equ(0) := (io.b_in.data.get.src(0).sign === io.b_in.data.get.src(1).sign)
  w_equ(1) := (io.b_in.data.get.src(0).expo === io.b_in.data.get.src(1).expo)
  w_equ(2) := (io.b_in.data.get.src(0).mant === io.b_in.data.get.src(1).mant)

//  when (w_equ(1)) {
//    when (w_equ(2)) {
//      w_agreat := false.B
//    }.otherwise {
//      w_agreat := (~io.b_in.data.get.src(0).sign & (io.b_in.data.get.src(0).mant > io.b_in.data.get.src(1).mant)) | (io.b_in.data.get.src(0).sign & (io.b_in.data.get.src(0).mant < io.b_in.data.get.src(1).mant))
//    }
//  }.otherwise {
//    w_agreat := (~io.b_in.data.get.src(0).sign & (io.b_in.data.get.src(0).expo > io.b_in.data.get.src(1).expo)) | (io.b_in.data.get.src(0).sign & (io.b_in.data.get.src(0).expo < io.b_in.data.get.src(1).expo))
//  }

  when (w_equ(1)) {
    when (w_equ(2)) {
      w_agreat := true.B
    }.otherwise {
      w_agreat := (io.b_in.data.get.src(0).mant > io.b_in.data.get.src(1).mant)
    }
  }.otherwise {
    w_agreat := (io.b_in.data.get.src(0).expo > io.b_in.data.get.src(1).expo)
  }

  when (w_equ(0)) {
    w_sgreat := (io.b_in.data.get.src(0).sign ^ w_agreat)
  }.otherwise {
    w_sgreat := io.b_in.data.get.src(0).sign
  }

  // ******************************
  //             SHIFT
  // ******************************
  val w_expo_diff = Wire(Vec(3, UInt(p.nExponentBit.W)))

  // Default
  for (s <- 0 until 3) {
    w_expo_diff(s) := 0.U
    w_neg(s) := false.B
    w_inf(s) := io.b_in.data.get.src(s).isInf()
  }
  w_uop := io.b_in.ctrl.get.ex.uop
  when (io.b_in.ctrl.get.ex.uop === UOP.SUB) {
    w_uop := UOP.ADD
  } 
  w_sign_same := (io.b_in.data.get.src(0).sign === io.b_in.data.get.src(1).sign)

  // Exponent difference
  when (~w_inf.asUInt.orR) {
    switch (io.b_in.ctrl.get.ex.uop) {
      is (UOP.ADD, UOP.SUB) {
        when (io.b_in.data.get.src(1).expo > io.b_in.data.get.src(0).expo) {
          w_expo_diff(0) := (io.b_in.data.get.src(1).expo - io.b_in.data.get.src(0).expo)
          w_expo_diff(1) := 0.U
        }.otherwise {
          w_expo_diff(0) := 0.U
          w_expo_diff(1) := (io.b_in.data.get.src(0).expo - io.b_in.data.get.src(1).expo)
        }
      }
    }
  }

  // Shift & Sub
  for (s <- 0 until 3) {
    w_src(s).sign := io.b_in.data.get.src(s).sign
    w_src(s).expo := (io.b_in.data.get.src(s).expo + w_expo_diff(s))
    w_src(s).mant := (Cat(1.U(1.W), io.b_in.data.get.src(s).mant) >> w_expo_diff(s))      
  }

  // Addition for negative number
  switch (io.b_in.ctrl.get.ex.uop) {
    is (UOP.ADD) {
      when (~w_sign_same) {
        when (~w_agreat) {
          w_neg(0) := true.B
          w_src(0).mant := (~(Cat(1.U(1.W), io.b_in.data.get.src(0).mant) >> w_expo_diff(0)) + 1.U)
        }.otherwise {
          w_neg(1) := true.B
          w_src(1).mant := (~(Cat(1.U(1.W), io.b_in.data.get.src(1).mant) >> w_expo_diff(1)) + 1.U)
        }
      } 
    }

    is (UOP.SUB) {
      w_src(1).sign := ~io.b_in.data.get.src(1).sign
      when (w_sign_same) {
        when (~w_agreat) {
          w_neg(0) := true.B
          w_src(0).mant := (~(Cat(1.U(1.W), io.b_in.data.get.src(0).mant) >> w_expo_diff(0)) + 1.U)
        }.otherwise {
          w_neg(1) := true.B
          w_src(1).mant := (~(Cat(1.U(1.W), io.b_in.data.get.src(1).mant) >> w_expo_diff(1)) + 1.U)
        }
      }
    }
  }

  // Special values
  for (s <- 0 until 3) {
    when (io.b_in.data.get.src(s).isZero()) {
      w_src(s) := NAN.PZERO(p.nExponentBit, p.nMantissaBit + 1)
      w_neg(s) := false.B
    }.elsewhen (io.b_in.data.get.src(s).iscNaN()) {
      w_src(s) := NAN.CNAN(p.nExponentBit, p.nMantissaBit + 1)
      w_neg(s) := false.B
    }.elsewhen (io.b_in.data.get.src(s).issNaN()) {
      w_src(s) := NAN.SNAN(p.nExponentBit, p.nMantissaBit + 1)
      w_neg(s) := false.B
    }.elsewhen (io.b_in.data.get.src(s).ispInf()) {
      w_src(s) := NAN.PINF(p.nExponentBit, p.nMantissaBit + 1)
      if (s == 1) w_src(s).sign := (io.b_in.ctrl.get.ex.uop === UOP.SUB)
      w_neg(s) := false.B
    }.elsewhen (io.b_in.data.get.src(s).isnInf()) {
      w_src(s) := NAN.NINF(p.nExponentBit, p.nMantissaBit + 1)
      if (s == 1) w_src(s).sign := (io.b_in.ctrl.get.ex.uop =/= UOP.SUB)
      w_neg(s) := false.B
    }
  }

  // ******************************
  //            ADDRESS
  // ******************************
  w_addr := io.b_in.data.get.src(0).asUInt + io.b_in.data.get.src(2).asUInt
  when (io.b_in.ctrl.get.mem) {
    w_src(0) := w_addr.asTypeOf(w_src(0))
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
    m_reg.get.io.b_in.ctrl.get.ex.uop := w_uop
    m_reg.get.io.b_in.data.get.src := w_src
    m_reg.get.io.b_in.data.get.equ := w_equ
    m_reg.get.io.b_in.data.get.agreat := w_agreat
    m_reg.get.io.b_in.data.get.sgreat := w_sgreat
    m_reg.get.io.b_in.data.get.neg := w_neg

    io.b_out <> m_reg.get.io.b_out 
  } else {
    io.b_in.ready := io.b_out.ready

    io.b_out.valid := io.b_in.valid
    io.b_out.ctrl.get := io.b_in.ctrl.get
    io.b_out.data.get.src := w_src
    io.b_out.data.get.equ := w_equ
    io.b_out.data.get.agreat := w_agreat
    io.b_out.data.get.sgreat := w_sgreat
    io.b_out.data.get.neg := w_neg
  }

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    dontTouch(w_agreat)
    dontTouch(w_sgreat)
    dontTouch(w_neg)
    dontTouch(w_sign_same)
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