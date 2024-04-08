/*
 * File: if.scala                                                              *
 * Created Date: 2024-04-08 09:31:37 am                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-08 02:23:54 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
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
import prj.common.lbus._
import prj.common.mbus._


class IfStage(p: BetizuParams) extends Module {
  val io = IO(new Bundle {
    val i_br_new = Input(new BranchBus(p))

    val o_br_next = Output(new BranchBus(p))
    val b_imem = new MBusIO(p.pL0IBus)

    val b_out = new GenRVIO(p, new FetchBus(p), UInt(0.W))
  })

  val init_pc = Wire(UInt(p.nAddrBit.W))

  init_pc := BigInt(p.pcBoot, 16).U

  val m_l0i = Module(new LBusMBus(p.pL0IBuffer))
  val m_fetch = if (p.useIfStage) Some(Module(new GenReg(p, new FetchBus(p), UInt(0.W), true))) else None
  val r_pc = RegInit(init_pc)

  val w_wait = Wire(Bool())
  val w_lock = Wire(Bool())
  val w_flush = Wire(Bool())

  // ******************************
  //             STATUS            
  // ******************************
  if (p.useIfStage || p.useIdStage) {
    w_flush := io.i_br_new.valid
  } else {
    w_flush := false.B
  }
  
  // ******************************
  //               PC
  // ******************************
  when (io.i_br_new.valid) {
    r_pc := io.i_br_new.addr
  }.elsewhen(~(w_lock | w_wait)) {
    r_pc := r_pc + 4.U
  }

  // ******************************
  //             FETCH
  // ******************************
  m_l0i.io.i_flush := w_flush

  w_wait := ~m_l0i.io.b_lbus.ready

  m_l0i.io.b_lbus.valid := ~w_lock & ~w_flush
  m_l0i.io.b_lbus.ctrl.rw := false.B
  m_l0i.io.b_lbus.ctrl.size := SIZE.toByte(p.nInstrByte.U)
  m_l0i.io.b_lbus.ctrl.addr := r_pc
  m_l0i.io.b_lbus.wdata := DontCare

  m_l0i.io.b_mbus <> io.b_imem

  if (p.useIfStage) {
    w_lock := ~m_fetch.get.io.b_in.ready

    m_fetch.get.io.b_in.valid := ~w_flush & ~w_wait
    m_fetch.get.io.b_in.ctrl.get.pc := r_pc
    m_fetch.get.io.b_in.ctrl.get.instr := m_l0i.io.b_lbus.rdata

    io.b_out <> m_fetch.get.io.b_out
  } else {
    w_lock := ~io.b_out.ready

    io.b_out.valid := ~w_flush & ~w_wait
    io.b_out.ctrl.get.pc := r_pc
    io.b_out.ctrl.get.instr := m_l0i.io.b_lbus.rdata
  }

  // ******************************
  //          NEXT BRANCH
  // ******************************
  io.o_br_next.valid := true.B
  io.o_br_next.addr := r_pc
}

object IfStage extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new IfStage(BetizuConfigBase),
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