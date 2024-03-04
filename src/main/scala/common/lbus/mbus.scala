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


package prj.common.lbus

import chisel3._
import chisel3.util._

import prj.common.gen._
import prj.common.mbus._


class LBusMBus (p: LBusMBusParams) extends Module {
  val io = IO(new Bundle { 
    val i_flush = Input(Bool())

    val b_lbus = Flipped(new LBusIO(p.pLBus))
    val b_mbus = new MBusIO(p.pMBus)
  })  

  io.b_lbus := DontCare
  io.b_mbus := DontCare

  // ******************************
  //             BUFFER
  // ******************************
  if ((p.nRBufferDepth > 0) && (p.nWBufferDepth > 0)) {
    val m_rdata = Module(new GenFifo(p, UInt(0.W), UInt(p.nDataBit.W), 4, p.nRBufferDepth, 1, 1))
    val m_wdata = Module(new GenFifo(p, UInt(0.W), UInt(p.nDataBit.W), 4, p.nWBufferDepth, 1, 1))

    val r_valid = RegInit(false.B)
    val r_fetch = RegInit(false.B)
    val r_abort = RegInit(false.B)

    val r_addr_fifo = Reg(UInt(p.nAddrBit.W))
    val r_addr_mbus = Reg(UInt(p.nAddrBit.W))

    val w_false = Wire(Bool())

    m_rdata.io.b_in(0) := DontCare
    m_wdata.io.b_in(0) := DontCare
    m_rdata.io.b_out(0) := DontCare
    m_wdata.io.b_out(0) := DontCare

    m_rdata.io.i_flush := io.i_flush | w_false
    m_wdata.io.i_flush := io.i_flush

    io.b_mbus.req.ctrl.rw := io.b_lbus.ctrl.rw
    io.b_mbus.req.ctrl.size := io.b_lbus.ctrl.size
    io.b_mbus.req.ctrl.addr := io.b_lbus.ctrl.addr
    m_wdata.io.b_in(0).data.get := io.b_lbus.wdata
    io.b_lbus.rdata := m_rdata.io.b_out(0).data.get

    io.b_mbus.write.valid := m_wdata.io.b_out(0).valid
    io.b_mbus.write.data := m_wdata.io.b_out(0).data.get


    when (io.b_lbus.ctrl.rw) {
      w_false := false.B

      io.b_lbus.ready := io.b_mbus.req.ready & m_wdata.io.b_in(0).ready
      io.b_mbus.req.valid := io.b_lbus.valid & m_wdata.io.b_in(0).ready
      m_wdata.io.b_in(0).valid := io.b_lbus.valid & io.b_mbus.req.ready
    }.otherwise {
      when (io.b_lbus.ctrl.addr(log2Ceil(p.nDataByte) - 1, 0) === r_addr_fifo(log2Ceil(p.nDataByte) - 1, 0)) {
        w_false := false.B
      }.otherwise {
        w_false := true.B

        io.b_lbus.ready := false.B
        io.b_mbus.req.valid := true.B
      }
    }

  // ******************************
  //           INTERFACE
  // ******************************
  } else {
    val r_valid = RegInit(false.B)

    io.b_mbus.req.ctrl.rw := io.b_lbus.ctrl.rw
    io.b_mbus.req.ctrl.size := io.b_lbus.ctrl.size
    io.b_mbus.req.ctrl.addr := io.b_lbus.ctrl.addr
    io.b_lbus.rdata := io.b_mbus.read.data
    io.b_mbus.write.data := io.b_lbus.wdata

    when (r_valid) {
      when (io.b_lbus.ctrl.rw) {
        r_valid := ~io.b_mbus.write.ready

        io.b_lbus.ready := io.b_mbus.write.ready
        io.b_mbus.req.valid := false.B
        io.b_mbus.read.ready := false.B  
        io.b_mbus.write.valid := true.B         
      }.otherwise {
        r_valid := ~io.b_mbus.read.valid

        io.b_lbus.ready := io.b_mbus.read.valid
        io.b_mbus.req.valid := false.B
        io.b_mbus.read.ready := true.B  
        io.b_mbus.write.valid := false.B   
      }
    }.otherwise {
      r_valid := io.b_lbus.valid & io.b_mbus.req.ready

      io.b_lbus.ready := false.B
      io.b_mbus.req.valid := io.b_lbus.valid
      io.b_mbus.read.ready := false.B  
      io.b_mbus.write.valid := false.B   
    }
  }

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    
  } 
}

object LBusMBus extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new LBusMBus(LBusMBusConfig0),
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