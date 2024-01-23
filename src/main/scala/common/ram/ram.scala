/*
 * File: ram.scala                                                             *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 12:16:08 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.common.ram

import chisel3._
import chisel3.util._
import chisel3.experimental._

import prj.common.gen._
import prj.common.mbus._


class RamSv (INITFILE: String, NDATA: Int, NDATABYTE: Int)
  extends BlackBox(Map( "INITFILE" -> INITFILE,
                        "NDATA" -> NDATA,
                        "NDATABYTE" -> NDATABYTE)) with HasBlackBoxResource {
  val io = IO(new Bundle() {
    val clock = Input(Clock())
    val reset = Input(Reset())

    val i_p1_en = Input(Bool())
    val i_p1_wen = Input(UInt(NDATABYTE.W))
    val i_p1_addr = Input(UInt(log2Ceil(NDATA).W))
    val i_p1_wdata = Input(UInt((NDATABYTE * 8).W))
    val o_p1_rdata = Output(UInt((NDATABYTE * 8).W))

    val i_p2_en = Input(Bool())
    val i_p2_wen = Input(UInt(NDATABYTE.W))
    val i_p2_addr = Input(UInt(log2Ceil(NDATA).W))
    val i_p2_wdata = Input(UInt((NDATABYTE * 8).W))
    val o_p2_rdata = Output(UInt((NDATABYTE * 8).W))
  })

  addResource("/sv/ram.sv")
}

class Ram (initFile: String, nData: Int, nDataByte: Int) extends Module {
  val io = IO(new Bundle() {
    val b_port = Vec(2, new RamIO(nDataByte, log2Ceil(nData)))
  })

  val m_ram = Module(new RamSv(initFile, nData, nDataByte))

  m_ram.io.clock := clock
  m_ram.io.reset := reset

  m_ram.io.i_p1_en := io.b_port(0).en
  m_ram.io.i_p1_wen := io.b_port(0).wen
  m_ram.io.i_p1_addr := io.b_port(0).addr
  m_ram.io.i_p1_wdata := io.b_port(0).wdata
  io.b_port(0).rdata := m_ram.io.o_p1_rdata

  m_ram.io.i_p2_en := io.b_port(1).en
  m_ram.io.i_p2_wen := io.b_port(1).wen
  m_ram.io.i_p2_addr := io.b_port(1).addr
  m_ram.io.i_p2_wdata := io.b_port(1).wdata
  io.b_port(1).rdata := m_ram.io.o_p2_rdata
}

class RamCtrl (p: RamCtrlParams) extends Module {
  require((p.nPort == 1) || (p.nPort == 2), "BRAM has only one or two ports.")

  val io = IO(new Bundle {    
    val b_read = Vec(p.nPort, new CtrlReadIO(p.nAddrBit, p.nDataByte))

    val b_write = Vec(p.nPort, new CtrlWriteIO(p.nAddrBit, p.nDataByte))

    val b_port = Flipped(Vec(2, new RamIO(p.nDataByte, p.nAddrBit)))
  })

  for (po <- 0 until 2) {
    io.b_port(po) := DontCare
    io.b_port(po).en := false.B
  }
  
  for (po <- 0 until p.nPort) {
    io.b_write(po).ready := true.B
    io.b_read(po).ready := ~io.b_write(po).valid 

    // ------------------------------
    //           READ DATA
    // ------------------------------
    val r_roffset = Reg(UInt(log2Ceil(p.nDataByte).W))

    r_roffset := io.b_read(po).addr(log2Ceil(p.nDataByte) - 1, 0)

    io.b_read(po).data := (io.b_port(po).rdata >> (r_roffset << 3.U))

    // ------------------------------
    //             WRITE
    // ------------------------------
    when (io.b_write(po).valid) {
      io.b_port(po).fromWrite(io.b_write(po))

    // ------------------------------
    //             READ
    // ------------------------------      
    }.otherwise {
      io.b_port(po).fromRead(io.b_read(po))
    }
  }  
  
  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {

  } 
}

class MBusRam (p: MBusRamParams) extends Module {
  val io = IO(new Bundle {    
    val b_port = MixedVec(
      for (po <- p.pPort) yield {
        val port = Flipped(new MBusIO(po))
        port
      }
    )
  })

  // ******************************
  //            MODULE
  // ******************************
  val m_ctrl = for (ctrl <- p.pCtrl) yield {
    val m_ctrl = Module(new MBusCtrl(ctrl))
    m_ctrl
  }
  val m_intf = Module(new RamCtrl(p))
  val m_ram = Module(new Ram(p.initFile, p.nData, p.nDataByte))

  m_ctrl(0).io.b_port <> io.b_port(0)
  m_ctrl(0).io.b_read <> m_intf.io.b_read(0)
  m_ctrl(0).io.b_write <> m_intf.io.b_write(0)

  if (p.nPort > 1) {
    m_ctrl(1).io.b_port <> io.b_port(1)
    m_ctrl(1).io.b_read <> m_intf.io.b_read(1)
    m_ctrl(1).io.b_write <> m_intf.io.b_write(1)
  }

  m_ram.io.b_port <> m_intf.io.b_port  
  
  // ******************************
  //            REPORT
  // ******************************
  def report (name: String): Unit = {
    println("------------------------------")
    println("Memory: " + name)
    println("Data size: " + p.nDataBit)
    println("Address base: 0x" + p.nAddrBase)
    println("Memory size: 0x" + p.nByte)
    println("------------------------------")
  }
  
  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    
  } 
}

object Ram extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Ram("", 2048, 4),
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

object RamCtrl extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new RamCtrl(RamCtrlConfigBase),
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

object MBusRam extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new MBusRam(MBusRamConfigBase),
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