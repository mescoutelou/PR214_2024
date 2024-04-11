/*
 * File: csr.scala                                                             *
 * Created Date: 2023-02-25 10:19:59 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-10 03:36:40 pm                                       *
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
import scala.math._

import emmk.common.isa.base._
import emmk.common.isa.base.CSR._


class Csr(p: BetizuParams) extends Module {
  val io = IO(new Bundle {
    val b_port = new CsrIO(p)

    val i_instret = Input(Vec(p.nFetchInstr, Bool()))

    val o_sim = if (p.isSim) Some(Output(new CsrBus())) else None
  })

  val w_rdata = Wire(UInt(p.nDataBit.W))
  val w_wdata = Wire(UInt(p.nDataBit.W))

  // ******************************
  //             INIT
  // ******************************
  val init_csr = Wire(new CsrBus())

  init_csr := DontCare
  init_csr.cycle := 0.U
  init_csr.time := 0.U
  init_csr.instret := 0.U

  val r_csr = RegInit(init_csr)

  // ******************************
  //            READ
  // ******************************
  io.b_port.ready := true.B
  io.b_port.rdata := w_rdata

  w_rdata := 0.U
  when (io.b_port.valid & io.b_port.read()) {
    switch (io.b_port.addr) {
      is (CYCLE.U)          {w_rdata := r_csr.cycle((p.nDataBit - 1),0)}
      is (TIME.U)           {w_rdata := r_csr.time((p.nDataBit - 1),0)}
      is (INSTRET.U)        {w_rdata := r_csr.instret((p.nDataBit - 1),0)}
    }

    if (p.nDataBit == 32) {
      switch (io.b_port.addr) {
        is (CYCLEH.U)         {w_rdata := r_csr.cycle(63,32)}
        is (TIMEH.U)          {w_rdata := r_csr.time(63,32)}
        is (INSTRETH.U)       {w_rdata := r_csr.instret(63,32)}
      }
    }
  }

  // ******************************
  //             WRITE
  // ******************************
  // ------------------------------
  //             DATA
  // ------------------------------
  w_wdata := 0.U

  switch (io.b_port.uop) {
    is (CSRUOP.W, CSRUOP.RW) {w_wdata := io.b_port.wdata}
    is (CSRUOP.S, CSRUOP.RS) {w_wdata := io.b_port.wdata | io.b_port.rdata}
    is (CSRUOP.C, CSRUOP.RC) {w_wdata := (io.b_port.wdata ^ io.b_port.rdata) & io.b_port.rdata}
  }

  // ------------------------------
  //            REGISTER
  // ------------------------------
//  when (io.b_port.modify()) {
//    switch (io.b_port.addr) {
//      is () {}
//    }
//  }

  // ******************************
  //           COUNTERS
  // ******************************
  r_csr.cycle := r_csr.cycle + 1.U
  r_csr.time := r_csr.time + 1.U
  r_csr.instret := r_csr.instret + PopCount(io.i_instret.asUInt)

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    dontTouch(w_rdata)
    dontTouch(w_wdata)
    dontTouch(r_csr)
    
    io.o_sim.get := r_csr     
  }
}

object Csr extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Csr(BetizuConfigBase),
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