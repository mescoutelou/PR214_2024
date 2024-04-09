/*
 * File: reg.scala                                                             *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 12:15:26 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.common.mbus

import chisel3._
import chisel3.util._

import emmk.common.gen._


class MBusReqReg(p: MBusReqParams, useReg: Boolean) extends Module {
  val io = IO(new Bundle { 
    val b_port = Flipped(new MBusReqIO(p))

    val o_back = Output(Bool())

    val b_out = new GenRVIO(p, new MBusReqBus(p), UInt(0.W))
  })  

  val w_lock = Wire(Bool())

  // ******************************
  //          BACK REGISTER
  // ******************************
  val m_back = Module(new GenReg(p, new MBusReqBus(p), UInt(0.W), false))

  val w_back = Wire(new GenVBus(p, new MBusReqBus(p), UInt(0.W)))  

  io.b_port.ready := m_back.io.b_in.ready

  // Write
  m_back.io.b_in.valid := io.b_port.valid & w_lock
  m_back.io.b_in.ctrl.get := io.b_port.ctrl

  // Read
  m_back.io.b_out.ready := ~w_lock
  when (m_back.io.b_out.valid) {
    w_back.valid := true.B
    w_back.ctrl.get := m_back.io.b_out.ctrl.get
  }.otherwise {
    w_back.valid := io.b_port.valid    
    w_back.ctrl.get := io.b_port.ctrl
  }
  

  // ******************************
  //         PORT REGISTER
  // ******************************
  val m_reg = if (useReg) Some(Module(new GenReg(p, new MBusReqBus(p), UInt(0.W), true))) else None

  // ------------------------------
  //             WITH
  // ------------------------------
  if (useReg) {
    // Write
    w_lock := ~m_reg.get.io.b_in.ready

    m_reg.get.io.b_in.valid := w_back.valid
    m_reg.get.io.b_in.ctrl.get := w_back.ctrl.get    
      
    // Outputs
    io.b_out <> m_reg.get.io.b_out
      
  // ------------------------------
  //            WITHOUT
  // ------------------------------
  } else {
    w_lock := ~io.b_out.ready    

    // Outputs
    io.b_out.valid := w_back.valid
    io.b_out.ctrl.get := w_back.ctrl.get        
  }

  // ******************************
  //        EXTERNAL ACCESS
  // ******************************
  io.o_back := m_back.io.o_val.valid

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    
  } 
}

class MBusDataReg(p: MBusDataParams) extends Module {
  val io = IO(new Bundle {  
    val b_port = Flipped(new MBusDataIO(p))

    val o_back = Output(Bool())

    val b_out = new GenRVIO(p, UInt(0.W), UInt((p.nDataByte * 8).W))
  })

  val w_lock = Wire(Bool())

  // ******************************
  //         OUTPUT REGISTER
  // ******************************
  val m_back = Module(new GenReg(p, UInt(0.W), UInt((p.nDataByte * 8).W), false))

  // Write
  io.b_port.ready := m_back.io.b_in.ready

  m_back.io.b_in.valid := io.b_port.valid & w_lock    
  m_back.io.b_in.data.get := io.b_port.data
  
  // Read
  w_lock := ~io.b_out.ready

  m_back.io.b_out.ready := ~w_lock 
  when (m_back.io.b_out.valid) {
    io.b_out.valid := true.B
    io.b_out.data.get := m_back.io.b_out.data.get
  }.otherwise {
    io.b_out.valid := io.b_port.valid    
    io.b_out.data.get := io.b_port.data
  }  

  // ******************************
  //        EXTERNAL ACCESS
  // ******************************
  io.o_back := m_back.io.o_val.valid  

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    
  } 
}

object MBusReqReg extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new MBusReqReg(MBusConfig0, true),
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

object MBusDataReg extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new MBusDataReg(MBusConfig0),
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