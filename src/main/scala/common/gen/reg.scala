/*
 * File: example.scala                                                         *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2023-12-21 07:27:31 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2023 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.common.gen

import chisel3._
import chisel3.util._


class GenReg[TC <: Data, TD <: Data](p: GenParams, tc: TC, td: TD, isPipe: Boolean) extends Module {  
  // ******************************
  //             I/Os
  // ******************************
  val io = IO(new Bundle {
    val b_in = Flipped(new GenRVIO(p, tc, td))

    val o_val = Output(new GenVBus(p, tc, td))
    val o_reg = Output(new GenVBus(p, tc, td))

    val b_out = new GenRVIO(p, tc, td)
  })

  // ******************************
  //         INIT REGISTERS
  // ******************************
  val init_reg = Wire(new GenVBus(p, tc, td))

  init_reg := DontCare
  init_reg.valid := false.B    

  val r_reg = RegInit(init_reg)

  // ******************************
  //            OUTPUT
  // ******************************  
  r_reg.valid := r_reg.valid & ~io.b_out.ready
  io.b_out.valid := r_reg.valid
  if (tc.getWidth > 0) io.b_out.ctrl.get := r_reg.ctrl.get
  if (td.getWidth > 0) io.b_out.data.get := r_reg.data.get

  // ******************************
  //            INPUT
  // ******************************
  val w_lock = Wire(Bool())

  if (isPipe) {
    w_lock := r_reg.valid & ~io.b_out.ready
  } else {
    w_lock := r_reg.valid
  }
  io.b_in.ready := ~w_lock
  
  when (io.b_in.valid & ~w_lock) {
    r_reg.valid := true.B
    if (tc.getWidth > 0) r_reg.ctrl.get := io.b_in.ctrl.get
    if (td.getWidth > 0) r_reg.data.get := io.b_in.data.get
  }  

  // ******************************
  //        EXTERNAL ACCESS
  // ******************************
  io.o_val := r_reg
  io.o_reg := r_reg

  // ******************************
  //           SIMULATION          
  // ******************************
  if (p.isSim) {
    dontTouch(io)
    dontTouch(w_lock)
  }
}

object GenReg extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new GenReg(GenConfigBase, UInt(8.W), UInt(8.W), false),
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
