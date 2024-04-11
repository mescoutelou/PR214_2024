/*
 * File: ex.scala                                                              *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-11 11:55:32 am                                       *
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


class ExStage(p: FpuParams) extends Module {
  val io = IO(new Bundle {
    val b_in = Flipped(new GenRVIO(p, new ExCtrlBus(p), new OperandBus(p)))

    val b_mem = new MBusReqIO(p.pDBus)
    val o_byp = Output(new BypassBus(p))

    val b_out = new GenRVIO(p, new WbCtrlBus(p), new ResultBus(p))
  })  

  val m_alu = Module(new Alu(p))
  val m_reg = if (p.useExStage) Some(Module(new GenReg(p, new WbCtrlBus(p), new ResultBus(p), true))) else None

  val w_lock = Wire(Bool())
  val w_wait = Wire(Bool())
  val w_res = Wire(new FloatBus(p.nExponentBit, p.nMantissaBit * 2))


  // ******************************
  //            EXECUTE
  // ******************************
  w_wait := false.B

  // ------------------------------
  //              ALU
  // ------------------------------
  m_alu.io.b_req.valid := io.b_in.valid
  m_alu.io.b_req.ctrl.get := io.b_in.ctrl.get.ex
  m_alu.io.b_req.data.get := io.b_in.data.get

  w_res := m_alu.io.b_ack.data.get
  m_alu.io.b_ack.ready := true.B

  // ------------------------------
  //         MEMORY REQUEST
  // ------------------------------
  io.b_mem.valid := io.b_in.valid & io.b_in.ctrl.get.mem
  io.b_mem.ctrl.rw := ~io.b_in.ctrl.get.fpr.en
  io.b_mem.ctrl.size := SIZE.B4.U
  io.b_mem.ctrl.addr := io.b_in.data.get.src(0).asUInt

  when (io.b_in.ctrl.get.mem) {
    w_wait := ~io.b_mem.ready
    w_res.sign := io.b_in.data.get.src(1).sign
    w_res.expo := io.b_in.data.get.src(1).expo
    w_res.mant := io.b_in.data.get.src(1).mant
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
  io.b_in.ready := ~w_wait & ~w_lock 

  if (p.useExStage) {
    w_lock := ~m_reg.get.io.b_in.ready

    m_reg.get.io.b_in.valid := io.b_in.valid & ~w_wait
    m_reg.get.io.b_in.ctrl.get.info := io.b_in.ctrl.get.info
    m_reg.get.io.b_in.ctrl.get.mem := io.b_in.ctrl.get.mem
    m_reg.get.io.b_in.ctrl.get.fpr := io.b_in.ctrl.get.fpr
    m_reg.get.io.b_in.data.get.res := w_res

    io.b_out <> m_reg.get.io.b_out 
  } else {
    w_lock := ~io.b_out.ready

    io.b_out.valid := io.b_in.valid & ~w_wait
    io.b_out.ctrl.get.info := io.b_in.ctrl.get.info
    io.b_out.ctrl.get.mem := io.b_in.ctrl.get.mem
    io.b_out.ctrl.get.fpr := io.b_in.ctrl.get.fpr
    io.b_out.data.get.res := w_res
  }

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    dontTouch(io.b_mem)
  }  
}

object ExStage extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new ExStage(FpuConfigBase),
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