/*
 * File: ibuffer.scala                                                         *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-09 09:57:24 am                                       *
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
import prj.common.mbus._


class IBuffer (p: BetizuParams) extends Module {
  val io = IO(new Bundle { 
    val i_redirect = Input(Bool())
    val i_pc = Input(UInt(p.nAddrBit.W))
    val b_out = new GenRVIO(p, UInt(p.nInstrBit.W), UInt(0.W))

    val b_imem = new MBusIO(p.pL0IBus)
  })  


  // ******************************
  //             BUFFER
  // ******************************
  if (p.nL0IBufferDepth > 1) {
    val m_instr = Module(new GenFifo(p, UInt(p.nInstrBit.W), UInt(0.W), 0, p.nL0IBufferDepth, 1, 1))

    val r_pc = Reg(UInt(p.nAddrBit.W))
    val r_imem = RegInit(VecInit(Seq.fill(2)(0.B)))
    val r_abort = RegInit(false.B)

    io.b_imem.req.valid := ~r_imem(1)
    io.b_imem.req.ctrl.rw := false.B
    io.b_imem.req.ctrl.size := SIZE.toByte(p.nInstrByte.U)
    io.b_imem.req.ctrl.addr := Mux(io.i_redirect, io.i_pc, r_pc)

    io.b_imem.write := DontCare
    io.b_imem.write.valid := false.B
    io.b_imem.read.ready := r_imem(0) & (m_instr.io.b_in(0).ready | io.i_redirect | r_abort)

    m_instr.io.i_flush := io.i_redirect
    m_instr.io.b_in(0).valid := r_imem(0) & ~io.i_redirect & ~r_abort
    m_instr.io.b_in(0).ctrl.get := io.b_imem.read.data

    m_instr.io.b_out(0) <> io.b_out
    io.b_out.valid := m_instr.io.b_out(0).valid & ~io.i_redirect

    when (io.i_redirect) {
      when (io.b_imem.req.ready & ~r_imem(1)) {
        r_pc := io.i_pc + 4.U
      }.otherwise {
        r_pc := io.i_pc
      }
    }.elsewhen(io.b_imem.req.ready & ~r_imem(1)) {
      r_pc := r_pc + 4.U
    }

    when (r_imem(0)) {
      r_imem(0) := r_imem(1) | io.b_imem.req.ready | ~(m_instr.io.b_in(0).ready | io.i_redirect | r_abort)
    }.otherwise {
      r_imem(0) := io.b_imem.req.ready
    }

    when (r_imem(1)) {
      r_imem(1) := ~(io.b_imem.read.valid & (m_instr.io.b_in(0).ready | io.i_redirect | r_abort))
    }.otherwise {
      r_imem(1) := r_imem(0) & io.b_imem.req.ready & ~(io.b_imem.read.valid & (m_instr.io.b_in(0).ready | io.i_redirect | r_abort))
    }

    when (r_imem(0)) {
      r_abort := (r_abort & ~io.b_imem.read.valid) | (~r_abort & io.i_redirect & (r_imem(1) | ~io.b_imem.read.valid))
    }.otherwise {
      r_abort := false.B
    }

  // ******************************
  //             DIRECT
  // ******************************
  } else {
    val r_done = RegInit(false.B)
    val r_abort = RegInit(false.B)

    io.b_imem.req.valid := ~r_done
    io.b_imem.req.ctrl.rw := false.B
    io.b_imem.req.ctrl.size := SIZE.toByte(p.nInstrByte.U)
    io.b_imem.req.ctrl.addr := io.i_pc

    io.b_imem.write := DontCare
    io.b_imem.write.valid := false.B
    io.b_imem.read.ready := r_done & (io.b_out.ready | io.i_redirect | r_abort)

    io.b_out.valid := r_done & io.b_imem.read.valid & ~io.i_redirect & ~r_abort
    io.b_out.ctrl.get := io.b_imem.read.data

    when (r_done) {
      r_done := ~(io.b_imem.read.valid & (io.b_out.ready | io.i_redirect | r_abort))
      r_abort := (~r_abort & io.i_redirect & ~io.b_imem.read.valid) | (r_abort & ~io.b_imem.read.valid)
    }.otherwise {
      r_done := io.b_imem.req.ready
      r_abort := false.B
    }
  }

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    
  } 
}

object IBuffer extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new IBuffer(BetizuConfigBase),
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