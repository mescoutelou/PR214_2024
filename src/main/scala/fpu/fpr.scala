/*
 * File: fpr.scala                                                             *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-15 11:36:49 am                                       *
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


class Fpr(p: FpuParams) extends Module {
  val io = IO(new Bundle {
    val b_read = Vec(3, new FprReadIO(p))
    val i_byp = Input(Vec(p.nBypass, new BypassBus(p)))
    val b_write = new FprWriteIO(p)

	  val o_sim = if (p.isSim) Some(Output(Vec(32, UInt(32.W)))) else None
  })  

  val r_fpr = Reg(Vec(32, new FloatBus(p.nExponentBit, p.nMantissaBit)))

  // ******************************
  //              READ            
  // ******************************
  for (r <- 0 until 3) {  
    // Read register
    io.b_read(r).ready := true.B
    io.b_read(r).data := r_fpr(io.b_read(r).addr)

    // Read Bypass
    for (b <- 0 until p.nBypass) {
      when (io.i_byp(b).valid & (io.i_byp(b).addr === io.b_read(r).addr)) {
        io.b_read(r).ready := io.i_byp(b).ready
        io.b_read(r).data := io.i_byp(b).data
      }
    }
  }

  // ******************************
  //             WRITE            
  // ******************************
  io.b_write.ready := true.B
  when (io.b_write.valid) {
    r_fpr(io.b_write.addr) := io.b_write.data
  }

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    for (f <- 0 until 32) {
      io.o_sim.get(f) := r_fpr(f).toUInt(p.nExponentBit, p.nMantissaBit)
    }
    dontTouch(io.o_sim.get)
  }  
}

object Fpr extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Fpr(FpuConfigBase),
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