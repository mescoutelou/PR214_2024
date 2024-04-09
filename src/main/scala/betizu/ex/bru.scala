/*
 * File: bru.scala                                                             *
 * Created Date: 2023-02-25 10:19:59 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-08 12:06:40 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.betizu

import chisel3._
import chisel3.util._

import emmk.common.gen._

class Bru (p: BetizuParams) extends Module {  
  import emmk.betizu.INTUOP._
  
  val io = IO(new Bundle {
    val b_in = Flipped(new GenRVIO(p, new IntUnitReqCtrlBus(p), new IntUnitReqDataBus(p)))

    val i_br_next = Input(new BranchBus(p))
    val o_br_new = Output(new BranchBus(p))

    val b_out = new GenRVIO(p, UInt(0.W), UInt(p.nDataBit.W))
  })

  val w_lock = Wire(Bool())

  // ******************************
  //            LOGIC
  // ******************************
  val w_sign = Wire(Bool())

  val w_br = Wire(Bool())
  val w_taken = Wire(Bool())
  val w_jmp = Wire(Bool())
  val w_flush = Wire(Bool())

  // ------------------------------
  //            DEFAULT
  // ------------------------------  
  w_sign := io.b_in.ctrl.get.ssign(0) | io.b_in.ctrl.get.ssign(1)

  w_br := false.B
  w_taken := false.B
  w_jmp := false.B
  w_flush := false.B

  switch (io.b_in.ctrl.get.uop) {
    // ------------------------------
    //             JUMP
    // ------------------------------
    is (JAL) {
      w_jmp := true.B
    }
    is (JALR) {
      w_jmp := true.B
    }

    // ------------------------------
    //            BRANCH
    // ------------------------------
    is (BEQ) {
      w_br := true.B
      w_taken := (io.b_in.data.get.s1 === io.b_in.data.get.s2)
    }
    is (BNE) {
      w_br := true.B
      w_taken := (io.b_in.data.get.s1 =/= io.b_in.data.get.s2)
    }
    is (BLT) {
      w_br := true.B
      when (w_sign) {
        w_taken := ((io.b_in.data.get.s1).asSInt < (io.b_in.data.get.s2).asSInt)
      }.otherwise {
        w_taken := (io.b_in.data.get.s1 < io.b_in.data.get.s2)
      }         
    }
    is (BGE) {
      w_br := true.B
      when (w_sign) {
        w_taken := ((io.b_in.data.get.s1).asSInt >= (io.b_in.data.get.s2).asSInt)
      }.otherwise {
        w_taken := (io.b_in.data.get.s1 >= io.b_in.data.get.s2)
      }         
    }
  }

  // ******************************
  //            ADDRESS
  // ******************************
  val w_addr = Wire(UInt(p.nAddrBit.W))
  val w_redirect = Wire(Bool())

  when (w_jmp) {
    w_addr := io.b_in.data.get.s1 + io.b_in.data.get.s2
  }.elsewhen(w_br & w_taken) {
    w_addr := io.b_in.ctrl.get.pc + io.b_in.data.get.s3
  }.otherwise {
    w_addr := io.b_in.ctrl.get.pc + 4.U    
  }

  w_redirect := io.b_in.valid & (~io.i_br_next.valid | (io.i_br_next.addr =/= w_addr)) 
  
  // ******************************
  //             OUTPUT
  // ******************************  
  io.b_in.ready := ~w_lock

  w_lock := ~io.b_out.ready

  io.o_br_new.valid := io.b_in.valid & ~w_lock & (w_redirect | w_flush)
  io.o_br_new.addr := Cat(w_addr(p.nAddrBit - 1, 2), 0.U(2.W))

  io.b_out.valid := io.b_in.valid
  io.b_out.data.get := io.b_in.ctrl.get.pc + 4.U

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    // ------------------------------
    //            SIGNALS
    // ------------------------------
    dontTouch(io.b_in)
    dontTouch(io.b_out)
    dontTouch(io.o_br_new)
  }
}

object Bru extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Bru(BetizuConfigBase),
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
