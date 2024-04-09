/*
 * File: gpr.scala                                                             *
 * Created Date: 2024-04-08 09:31:37 am                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-08 02:17:19 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.betizu

import chisel3._
import chisel3.util._

import emmk.common.isa.base._


class Gpr(p: BetizuParams) extends Module {
  val io = IO(new Bundle {
    val b_read = Vec(2, new GprReadIO(p))
    val i_byp = Input(Vec(p.nGprBypass, new BypassBus(p)))
    val b_write = new GprWriteIO(p)

    val o_sim = if (p.isSim) Some(Output(Vec(32, UInt(p.nDataBit.W)))) else None  
  })

  val r_gpr = Reg(Vec(32, UInt(p.nDataBit.W)))
  
  // ******************************
  //              READ
  // ******************************
  // ------------------------------
  //            REGISTER
  // ------------------------------
  for (r <- 0 until 2) {
    io.b_read(r).ready := true.B
    io.b_read(r).data := 0.U
    when (io.b_read(r).addr =/= REG.X0.U) {
      io.b_read(r).data := r_gpr(io.b_read(r).addr)
    }
  }

  // ------------------------------
  //            BYPASS
  // ------------------------------
  for (r <- 0 until 2) {
    for (b <- 0 until p.nGprBypass) {
      when (io.i_byp(b).valid & (io.i_byp(b).addr === io.b_read(r).addr) & (io.b_read(r).addr =/= REG.X0.U)) {
        if (p.useGprBypass) {
          io.b_read(r).ready := io.i_byp(b).ready
          io.b_read(r).data := io.i_byp(b).data
        } else {
          io.b_read(r).ready := false.B
        }        
      }
    }
  }

  // ******************************
  //             WRITE
  // ******************************  
  when(io.b_write.valid & (io.b_write.addr =/= REG.X0.U)) {
    r_gpr(io.b_write.addr) := io.b_write.data
  }  

  // ******************************
  //           FIXED X0
  // ******************************
  r_gpr(0) := 0.U  

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    // ------------------------------
    //            SIGNALS
    // ------------------------------
    for (i <- 0 until 32) {
      io.o_sim.get(i) := r_gpr(i)
    }
    
    dontTouch(r_gpr)
  }
}

object Gpr extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Gpr(BetizuConfigBase),
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