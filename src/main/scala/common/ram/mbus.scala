/*
 * File: mbus.scala                                                            *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 12:15:47 pm                                       *
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


class MBusCtrl (p: MBusCtrlParams) extends Module {
  val io = IO(new Bundle {
    val b_port = Flipped(new MBusIO(p.pPort))
   
    val b_read = Flipped(new CtrlReadIO(p.nAddrBit, p.nDataByte))

    val b_write = Flipped(new CtrlWriteIO(p.nAddrBit, p.nDataByte))
  })

  val m_req = Module(new MBusReqReg(p.pPort, p.useReqReg))
  val m_ack = Module(new GenReg(p, new MBusReqBus(p.pPort), UInt(0.W), true))

  // ******************************
  //              REQ
  // ******************************  
  val w_req = Wire(new GenVBus(p, new MBusReqBus(p.pPort), UInt(0.W)))

  val w_req_wait = Wire(Bool())  

  val w_req_rwait = Wire(Bool())
  val w_req_wwait = Wire(Bool())
  val w_req_await = Wire(Bool())

  // ------------------------------
  //             INPUT
  // ------------------------------
  m_req.io.b_port <> io.b_port.req
  m_req.io.b_out.ready := ~w_req_wait & ~w_req_await

  w_req.valid := m_req.io.b_out.valid
  w_req.ctrl.get := m_req.io.b_out.ctrl.get
  if (p.readOnly) w_req.ctrl.get.rw := false.B

  // ------------------------------
  //             WAIT
  // ------------------------------  
  w_req_rwait := w_req.valid & ~w_req.ctrl.get.rw & ~io.b_read.ready  
  if (p.isRom || p.readOnly) {
    w_req_wwait := false.B
  } else {
    w_req_wwait := m_ack.io.o_val.valid & m_ack.io.o_val.ctrl.get.rw & ~w_req.ctrl.get.rw  
  }  

  w_req_wait := w_req_rwait | w_req_wwait

  // ------------------------------
  //             READ
  // ------------------------------
  io.b_read.valid := w_req.valid & ~w_req.ctrl.get.rw & ~w_req_await & ~w_req_wwait   
  io.b_read.mask := SIZE.toMask(p.nDataByte, w_req.ctrl.get.size)
  io.b_read.addr := w_req.ctrl.get.addr  

  // ******************************
  //             ACK
  // ******************************  
  val w_ack = Wire(new GenVBus(p, new MBusReqBus(p.pPort), UInt(0.W)))  

  val w_ack_wait = Wire(Bool())
  val w_ack_pwait = Wire(Bool())
  val w_mbus_wwait = Wire(Bool())
  val w_mbus_rwait = Wire(Bool())
  
  // ------------------------------
  //           REGISTER
  // ------------------------------  
  w_req_await := ~m_ack.io.b_in.ready
  m_ack.io.b_in.valid := w_req.valid & ~w_req_wait
  m_ack.io.b_in.ctrl.get := w_req.ctrl.get

  m_ack.io.b_out.ready := ~w_ack_wait & ~w_ack_pwait
  w_ack.valid := m_ack.io.b_out.valid
  w_ack.ctrl.get := m_ack.io.b_out.ctrl.get

  // ------------------------------
  //            WRITE
  // ------------------------------
  val m_wmbus = if (!p.readOnly && !p.isRom) Some(Module(new MBusDataReg(p.pPort))) else None

  if (!p.readOnly && !p.isRom) {
    // MBus write port
    m_wmbus.get.io.b_port <> io.b_port.write

    m_wmbus.get.io.b_out.ready := w_ack.valid & w_ack.ctrl.get.rw & ~w_ack_wait

    // Memory write port
    w_ack_wait := w_ack.valid & w_ack.ctrl.get.rw & ~io.b_write.ready

    io.b_write.valid := w_ack.valid & w_ack.ctrl.get.rw & ~w_ack_pwait
    io.b_write.addr := w_ack.ctrl.get.addr
    io.b_write.mask := SIZE.toMask(p.nDataByte, w_ack.ctrl.get.size)
    io.b_write.data := m_wmbus.get.io.b_out.data.get
  } else {
    // MBus write port
    io.b_port.write.ready := false.B    

    // Memory write port
    w_ack_wait := false.B

    io.b_write := DontCare
    io.b_write.valid := false.B
  }

  // ------------------------------
  //             READ
  // ------------------------------
  val r_rdata_av = RegInit(false.B)
  val r_rdata = Reg(UInt((p.nDataByte * 8).W))

  val w_rdata_av = Wire(Bool())
  val w_rdata = Wire(UInt((p.nDataByte * 8).W))

  // Read data buffer
  when (~r_rdata_av) {
    r_rdata_av := m_ack.io.o_val.valid & ~m_ack.io.o_val.ctrl.get.rw & w_ack_pwait
    r_rdata := io.b_read.data
  }

  when (r_rdata_av) {
    r_rdata_av := w_ack_pwait
  }  

  w_rdata_av := r_rdata_av
  w_rdata := r_rdata
  
  // Memory read port  
  io.b_port.read.valid := w_ack.valid & ~w_ack.ctrl.get.rw & ~w_ack_wait
  io.b_port.read.data := Mux(w_rdata_av, w_rdata, io.b_read.data)  

  // ------------------------------
  //             WAIT
  // ------------------------------
  if (!p.readOnly && !p.isRom) w_mbus_wwait := w_ack.ctrl.get.rw & ~m_wmbus.get.io.b_out.valid else w_mbus_wwait := false.B
  w_mbus_rwait := ~w_ack.ctrl.get.rw & ~io.b_port.read.ready

  w_ack_pwait := w_ack.valid & (w_mbus_wwait | w_mbus_rwait)

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    dontTouch(io.b_port)
  } 
}

object MBusCtrl extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new MBusCtrl(MBusCtrlConfigBase),
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
