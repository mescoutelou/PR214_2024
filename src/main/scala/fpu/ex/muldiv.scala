/*
 * File: muldiv.scala                                                          *
 * Created Date: 2023-02-25 10:19:59 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-10 01:12:24 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */

/*
package emmk.fpu

import chisel3._
import chisel3.util._
import scala.math._

import emmk.common.gen._ 


class MulShiftOp(p: FpuParams, nOpLevel: Int) extends Module {
  def nRound: Int = p.nMantissaBit / pow(2, nOpLevel).toInt

  val io = IO(new Bundle {
    val i_s1 = Input(UInt(p.nMantissaBit.W))
    val i_s2 = Input(UInt(p.nMantissaBit.W))
    val i_round = Input(UInt(log2Ceil(nRound).W))

    val o_res = Output(UInt((p.nMantissaBit * 2).W))
  })

  val w_op = Wire(Vec(pow(2, nOpLevel + 1).toInt - 1, UInt((p.nMantissaBit * 2).W)))

  // Format inputs
  for (na <- 0 until pow(2, nOpLevel).toInt) {
    val w_bit = (io.i_round << nOpLevel.U) + na.U

    w_op(na) := Mux(io.i_s2(w_bit), (io.i_s1 << w_bit), 0.U)
  }

  var opoff: Int = 0

  // Operation levels
  for (al <- nOpLevel to 1 by -1) {
    for (na <- 0 until pow(2, al - 1).toInt) {    
      w_op(opoff + pow(2, al).toInt + na) := w_op(opoff + na * 2) + w_op(opoff + na * 2 + 1)   
    }

    opoff = opoff + pow(2, al).toInt
  }

  // Result = last w_op
  io.o_res := w_op(pow(2, nOpLevel + 1).toInt - 2)
}

//class DivShiftSub(p: FpuParams) extends Module {
//  val io = IO(new Bundle {
//    val i_s1 = Input(UInt(p.nDataBit.W))
//    val i_s2 = Input(UInt(p.nDataBit.W))
//    val i_round = Input(UInt(log2Ceil(p.nDataBit).W))
//    val i_quo = Input(UInt(p.nDataBit.W))
//    val i_rem = Input(UInt(p.nDataBit.W))
//
//    val o_quo = Output(UInt(p.nDataBit.W))
//    val o_rem = Output(UInt(p.nDataBit.W))
//  })
//
//  val w_old_rem = Wire(UInt(p.nDataBit.W))
//  val w_old_quo = Wire(UInt(p.nDataBit.W))
//  
//  w_old_rem := io.i_rem << 1.U
//  w_old_quo := io.i_quo << 1.U
//
//  // ******************************
//  //         NEW DIVIDEND
//  // ******************************  
//  val w_div = Wire(Vec(p.nDataBit, Bool()))
//
//  w_div := w_old_rem.asBools
//  w_div(0) := io.i_s1((p.nDataBit - 1).U - io.i_round)
//
//  // ******************************
//  //   NEW QUOTIENT AND REMAINDER
//  // ******************************
//  val w_quo = Wire(Vec(p.nDataBit, Bool()))
//  val w_rem = Wire(UInt(p.nDataBit.W))
//
//  w_quo := w_old_quo.asBools
//
//  when (w_div.asUInt >= io.i_s2) {
//    w_quo(0) := 1.B
//    w_rem := w_div.asUInt - io.i_s2
//  }.otherwise {
//    w_quo(0) := 0.B
//    w_rem := w_div.asUInt
//  }
//
//  io.o_quo := w_quo.asUInt
//  io.o_rem := w_rem
//}

object MulDivFSM extends ChiselEnum {
  val s0IDLE, s1MUL, s2DIV, s3SQRT = Value
}

class MulDiv (p: FpuParams, isPipe: Boolean, nMulLevel: Int) extends Module {
  import emmk.fpu.MulDivFSM._

  require((nMulLevel < log2Ceil(p.nMantissaBit)), "MulDiv unit must have less adder levels.")

  val io = IO(new Bundle {
    val i_flush = Input(Bool())

    val b_req = Flipped(new GenRVIO(p, new ExBus(p), new OperandBus(p)))
    val b_ack = new GenRVIO(p, UInt(0.W), new FloatBus(p.nExponentBit, p.nMantissaBit * 2))
  })

  val m_src = Module(new GenReg(p, UInt(0.W), Vec(2, new FloatBus(p.nExponentBit, p.nMantissaBit)), false))
  val m_tmp = Module(new GenReg(p, UInt(0.W), new FloatBus(p.nExponentBit, p.nMantissaBit * 2), false))

  val w_flush = Wire(Bool())
  val w_end = Wire(Bool())
  val w_lock = Wire(Bool())

  // ******************************
  //             STATUS            
  // ******************************
  w_flush := io.i_flush

  // ******************************
  //              FSM
  // ******************************
  val r_fsm = RegInit(s0IDLE)
  val r_round = Reg(UInt(log2Ceil(p.nDataBit).W))

  when ((r_fsm === s1MUL) | (r_fsm === s2DIV) | (r_fsm === s3SQRT)) {
    when (w_flush | (w_end & ~w_lock)) {
      r_fsm := s0IDLE
    }
  }.otherwise {
    r_fsm := s0IDLE
    when (io.b_port.req.valid & ~w_flush) {
      switch (io.b_port.req.ctrl.get.uop) {
        is (UOP.MUL)  {r_fsm := s1MUL}
        is (UOP.DIV)  {r_fsm := s2DIV}
        is (UOP.SQRT) {r_fsm := s3SQRT}
      }
    }
  }

  io.b_port.req.ready := (r_fsm === s0IDLE)

  // ******************************
  //             STATE
  // ******************************
  m_src.io.b_out.ready := w_end & ~w_lock
  m_src.io.b_in.valid := false.B
  m_src.io.b_in.data.get := DontCare

  val w_nround = Wire(UInt(log2Ceil(p.nDataBit).W))
  val w_src_zero = Wire(Bool())
  val w_src_nan = Wire(Bool())
  val w_mul_nomore = Wire(Bool())
  val w_div_zero = Wire(Bool())
  val w_div_start = Wire(UInt(log2Ceil(p.nDataBit).W))

  // ------------------------------
  //           REGISTERS
  // ------------------------------
  when ((r_fsm === s1MUL) | (r_fsm === s2DIV) | (r_fsm === s3SQRT)) {
    when (w_flush) {
      r_round := 0.U
    }.elsewhen(w_end) {
      when (~w_lock) {
        r_round := 0.U
      }
    }.otherwise {
      r_round := w_nround
    }
  }.otherwise {
    when (io.b_port.req.valid & ~w_flush) {
      r_round := 1.U

      m_src.io.b_in.valid := true.B
      m_src.io.b_in.data.get(0) := w_us1_in
      m_src.io.b_in.data.get.us2 := w_us2_in
      m_src.io.b_in.data.get.s1_sign := w_s1_sign
      m_src.io.b_in.data.get.s2_sign := w_s2_sign
    }.otherwise {
      r_round := 0.U
    }
  }

  // ------------------------------
  //             END
  // ------------------------------
  when ((r_fsm === s1MUL) | (r_fsm === s3SQRT)) {
    w_end := (r_round === ((p.nDataBit / pow(2, nMulLevel).toInt) - 1).U) | w_src_zero | w_mul_nomore
  }.elsewhen (r_fsm === s2DIV) {
    w_end := (r_round === (p.nDataBit - 1).U) | w_src_zero | w_div_zero
  }.otherwise {
    w_end := false.B
  }

  // ------------------------------
  //          NEXT ROUND
  // ------------------------------
  when ((r_fsm === s2DIV) & (r_round < (w_div_start))) {
    w_nround := w_div_start
  }.otherwise {
    w_nround := r_round + 1.U
  }  

  // ------------------------------
  //         SPECIFIC CASES
  // ------------------------------
  // Accelerated result
  val w_s2_rest = Wire(Vec(p.nDataBit, Bool()))

  for (b <- 0 until p.nDataBit) {
    w_s2_rest(b) := (b.U >= ((r_round + 1.U) << nMulLevel.U)) & m_src.io.o_val.data.get.us2(b)
  }
  w_div_start := PriorityEncoder(Reverse(m_src.io.o_val.data.get.us1))
  w_mul_nomore := (w_s2_rest.asUInt === 0.U)

  // Instantaneous result
  w_src_zero := (m_src.io.o_val.data.get.us1 === 0.U) | (m_src.io.o_val.data.get.us2 === 0.U)
  w_div_zero := (m_src.io.o_val.data.get.us2 === 0.U)  
  w_div_over := (m_src.io.o_val.data.get.s1_sign ^ m_src.io.o_val.data.get.s2_sign) & (m_src.io.o_val.data.get.us1 === Cat(1.B, Fill(p.nDataBit - 1, 0.B))) & (m_src.io.o_val.data.get.us2 === Fill(p.nDataBit, 1.B))
  
  // ******************************
  //             DATA
  // ******************************
  m_tmp.io.i_flush := io.i_flush

  m_tmp.io.b_out.ready := w_end & ~w_lock
  m_tmp.io.b_in.valid := false.B
  m_tmp.io.b_in.data.get := DontCare
  m_tmp.io.i_up.get.data.get := m_tmp.io.b_out.data.get

  val w_tmp_acc = Wire(UInt((p.nDataBit * 2).W))
  
  // ------------------------------
  //             UNITS
  // ------------------------------
  val m_mulsa = Module(new MulShiftOp(p.nDataBit, nMulLevel, true))

  m_mulsa.io.i_round := r_round
  m_mulsa.io.i_s1 := Mux((r_fsm === s1MUL), m_src.io.o_val.data.get.us1, w_us1_in)
  m_mulsa.io.i_s2 := Mux((r_fsm === s1MUL), m_src.io.o_val.data.get.us2, w_us2_in)

  val m_divss = Module(new DivShiftSub(p.nDataBit))

  m_divss.io.i_round := r_round
  m_divss.io.i_s1 := Mux((r_fsm === s2DIV), m_src.io.o_val.data.get.us1, w_us1_in)
  m_divss.io.i_s2 := Mux((r_fsm === s2DIV), m_src.io.o_val.data.get.us2, w_us2_in)
  m_divss.io.i_quo := Mux((r_fsm === s2DIV), m_tmp.io.o_val.data.get, 0.U)
  m_divss.io.i_rem := Mux((r_fsm === s2DIV), m_tmp.io.o_val.data.get, 0.U)

  // ------------------------------
  //        TEMPORARY VALUES
  // ------------------------------
  when (r_fsm === s1MUL) {
    w_tmp_acc := Cat(m_tmp.io.o_val.data.get.uhrem, m_tmp.io.o_val.data.get.ulquo) + m_mulsa.io.o_res
  }.elsewhen(r_fsm === s3SQRT) {
    w_tmp_acc := DontCare       
  }.otherwise {
    w_tmp_acc := m_mulsa.io.o_res
  }  

  when ((r_fsm === s1MUL) | (r_fsm === s3SQRT)) {
    when (~w_end) {
      m_tmp.io.i_up.get.data.get.ulquo := w_tmp_acc(p.nDataBit - 1, 0)
      m_tmp.io.i_up.get.data.get.uhrem := w_tmp_acc(p.nDataBit * 2 - 1, p.nDataBit)
    }
  }.elsewhen (r_fsm === s2DIV) {
    when (~w_end) {
      m_tmp.io.i_up.get.data.get.ulquo := m_divss.io.o_quo
      m_tmp.io.i_up.get.data.get.uhrem := m_divss.io.o_rem
    }    
  }.otherwise {
    when (io.b_port.req.valid & ~w_flush) {
      m_tmp.io.b_in.valid := true.B
      m_tmp.io.b_in.data.get.ulquo := w_tmp_acc(p.nDataBit - 1, 0)
      m_tmp.io.b_in.data.get.uhrem := w_tmp_acc(p.nDataBit * 2 - 1, p.nDataBit)
      when (~w_dec(0)) {
        m_tmp.io.b_in.data.get.ulquo := m_divss.io.o_quo
        m_tmp.io.b_in.data.get.uhrem := m_divss.io.o_rem
      }      
    }
  }

  // ******************************
  //             RESULT
  // ******************************
  val w_fin = Wire(UInt(p.nDataBit.W))

  // ------------------------------
  //            RESIZE
  // ------------------------------
  val w_uacc = Wire(UInt((p.nDataBit * 2).W))
  val w_uquo = Wire(UInt(p.nDataBit.W))
  val w_urem = Wire(UInt(p.nDataBit.W))

  w_uquo := DontCare
  w_urem := DontCare

  w_uacc := w_tmp_acc
  w_uquo := m_divss.io.o_quo
  w_urem := m_divss.io.o_rem   

  // ------------------------------
  //         SIGN (U TO S)
  // ------------------------------
  val w_acc = Wire(UInt((p.nDataBit * 2).W))
  val w_quo = Wire(UInt(p.nDataBit.W))
  val w_rem = Wire(UInt(p.nDataBit.W))

  when (w_src_zero) {
    w_acc := 0.U
  }.otherwise {
    w_acc := Mux(m_src.io.o_val.data.get.s1_sign ^ m_src.io.o_val.data.get.s2_sign, (~w_uacc) + 1.U, w_uacc)
  }

  when (w_div_zero) {
    w_quo := Fill(p.nDataBit, 1.B)
    w_rem := Mux(m_src.io.o_val.data.get.s1_sign, (~m_src.io.o_val.data.get.us1) + 1.U, m_src.io.o_val.data.get.us1)
  }.elsewhen (w_div_over) {
    w_quo := (~m_src.io.o_val.data.get.us1) + 1.U
    w_rem := 0.U
  }.elsewhen (w_src_zero) {
    w_quo := 0.U
    w_rem := 0.U
  }.otherwise {
    w_quo := Mux(m_src.io.o_val.data.get.s1_sign ^ m_src.io.o_val.data.get.s2_sign, (~w_uquo) + 1.U, w_uquo)
    w_rem := Mux(m_src.io.o_val.data.get.s1_sign, (~w_urem) + 1.U, w_urem)
  }

  // ------------------------------
  //            SELECT
  // ------------------------------
  w_fin := DontCare

  when (r_fsm === s1MUL) {
    w_fin := w_acc(p.nDataBit - 1, 0)    
  }

  when (r_fsm === s2DIV) {
    w_fin := w_quo        
  }  

  // ******************************
  //            OUTPUTS
  // ******************************
  val m_ack = if (isPipe) Some(Module(new GenReg(p, new IntUnitAckCtrlBus(0), UInt(p.nDataBit.W), true, false, false, true))) else None

  // ------------------------------
  //            REGISTER
  // ------------------------------
  if (isPipe) {
    m_ack.get.io.i_flush := io.i_flush

    w_lock := ~m_ack.get.io.b_in.ready

    m_ack.get.io.b_in.valid := w_end
    m_ack.get.io.b_in.ctrl.get := DontCare
    m_ack.get.io.b_in.data.get := w_fin

    m_ack.get.io.b_out <> io.b_port.ack
  
  // ------------------------------
  //             DIRECT
  // ------------------------------
  } else {
    w_lock := ~io.b_port.ack.ready

    io.b_port.ack.valid := w_end
    io.b_port.ack.ctrl.get := DontCare
    io.b_port.ack.data.get := w_fin
  }  

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {    
    // ------------------------------
    //            SIGNALS
    // ------------------------------
    dontTouch(io.b_port)
  }
}

object MulShift extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new MulShiftOp(FpuConfigBase, 3),
    firtoolOpts = Array.concat(
      Array(
        "--disable-all-randomization",
        "--strip-debug-info",
        "--verilog"
      ),
      args
    )      
  )
}

object DivShiftSub extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new DivShiftSub(FpuConfigBase),
    firtoolOpts = Array.concat(
      Array(
        "--disable-all-randomization",
        "--strip-debug-info",
        "--verilog"
      ),
      args
    )      
  )
}

object MulDiv extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new MulDiv(FpuConfigBase, true, 4),
    firtoolOpts = Array.concat(
      Array(
        "--disable-all-randomization",
        "--strip-debug-info",
        "--verilog"
      ),
      args
    )      
  )
}
*/