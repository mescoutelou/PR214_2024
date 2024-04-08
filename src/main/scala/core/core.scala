package prj.core

import chisel3._
import chisel3.util._
import _root_.circt.stage.{ChiselStage}

class Core extends Module {
  val io = IO(new Bundle {
    val i_mem = Input(UInt(32.W))
    val o_mem = Output(UInt(32.W))

//    val b_imem = new MBusIO(p.pIBus)
//    val b_dmem = new MBusIO(p.pDBus)
//
//	  val o_sim = if (p.isSim) Some(Output(Vec(32, UInt(32.W)))) else None
  })

  val back = Module(new Back)
  val fetch = Module(new fetch)

  fetch.io.i_jumpAdr := DontCare
  fetch.io.i_jumpEnable := DontCare
  back.io.i_instr := io.i_mem
  io.o_mem := fetch.io.o_instrAdr 

//  val m_l0i = Module(new LBusMBus(p.pILBusMBus))
//
//  m_l0i.io.i_flush := false.B 
//  m_l0i.io.b_lbus := DontCare
//
//  io.b_imem <> m_l0i.io.b_mbus
//  io.b_dmem := DontCare

  // ******************************
  //           SIMULATION
  // ******************************
//  if (p.isSim) {
//    io.o_sim.get := DontCare
//    dontTouch(io.o_sim.get)
//  }  
}

object Core extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Core,
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