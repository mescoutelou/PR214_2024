/*
 * File: rr.scala                                                              *
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


class SlctOp(p: FloatParams) extends Module {
  val io = IO(new Bundle {
    val i_op = Input(UInt(OP.NBIT.W))

    val i_int = Input(UInt(p.nDataBit.W))
    val i_float = Input(new FloatBus(p))

    val o_val = Output(new FloatBus(p))
  })  

  io.o_val := 0.U.asTypeOf(io.o_val)

  switch (io.i_op) {
    is (OP.INT)   {io.o_val.fromUInt(io.i_int)}
    is (OP.FLOAT) {io.o_val := io.i_float}
  }
}


class RrStage(p: FpuParams) extends Module {
  val io = IO(new Bundle {
    val b_pipe = Flipped(new FpuReqIO(p, p.nDataBit))

    val b_rs = Vec(3, Flipped(new FprReadIO(p)))

    val b_out = new GenRVIO(p, new ShiftCtrlBus(p), new DataBus(p))
  })  

  val m_reg = Module(new GenReg(p, new ShiftCtrlBus(p), new DataBus(p), true))

  val w_lock = Wire(Bool())
  val w_wait_rs = Wire(Vec(3, Bool()))
  val w_src = Wire(Vec(3, new FloatBus(p)))

  // ******************************
  //            DECODER
  // ******************************
  val w_decoder = ListLookup(io.b_pipe.ctrl.get.code, TABLECODE.default, TABLECODE.table)

  // ******************************
  //             SOURCE
  // ******************************
  for (s <- 0 until 3) {
    val m_slct_op = Module(new SlctOp(p))
    
    io.b_rs(s).addr := io.b_pipe.ctrl.get.rs(s)

    w_wait_rs(s) := (io.b_pipe.ctrl.get.op(s) === OP.FLOAT) & ~io.b_rs(s).ready
    m_slct_op.io.i_op := io.b_pipe.ctrl.get.op(s)
    m_slct_op.io.i_int := io.b_pipe.data.get.src(s)
    m_slct_op.io.i_float := io.b_rs(s).data

    w_src(s) := m_slct_op.io.o_val
  }
  
  // ******************************
  //             OUTPUT
  // ******************************
  io.b_pipe.ready := ~w_lock & ~w_wait_rs.asUInt.orR

  w_lock := ~m_reg.io.b_in.ready
  m_reg.io.b_in.valid := io.b_pipe.valid
  m_reg.io.b_in.ctrl.get.info.wb := io.b_pipe.ctrl.get.wb
  m_reg.io.b_in.ctrl.get.ex.uop := w_decoder(1)
  m_reg.io.b_in.ctrl.get.fpr.en := w_decoder(2)
  m_reg.io.b_in.ctrl.get.fpr.addr := io.b_pipe.ctrl.get.rd
  m_reg.io.b_in.data.get.src := w_src

  io.b_out <> m_reg.io.b_out 

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    dontTouch(io.b_pipe)
    dontTouch(w_src)
    dontTouch(io.b_out)
  }  
}

object RrStage extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new RrStage(FpuConfigBase),
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