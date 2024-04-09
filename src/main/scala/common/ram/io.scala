/*
 * File: io.scala                                                              *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 12:11:22 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.common.ram

import chisel3._
import chisel3.util._

import emmk.common.mbus.{SIZE}


// ******************************
//             CTRL
// ******************************
class CtrlReadIO (nAddrBit: Int, nDataByte: Int) extends Bundle {
  val ready = Output(Bool())
  val valid = Input(Bool())
  val mask = Input(UInt(nDataByte.W))
  val addr = Input(UInt(nAddrBit.W))
  val data = Output(UInt((nDataByte * 8).W))
}

class CtrlWriteIO (nAddrBit: Int, nDataByte: Int) extends Bundle {
  val ready = Output(Bool())
  val valid = Input(Bool())
  val mask = Input(UInt(nDataByte.W))
  val addr = Input(UInt(nAddrBit.W))
  val data = Input(UInt((nDataByte * 8).W))
}

// ******************************
//             RAM
// ******************************
class RamIO (nDataByte: Int, nAddrBit: Int) extends Bundle {
  val en = Input(Bool())
  val wen = Input(UInt(nDataByte.W))
  val addr = Input(UInt(nAddrBit.W))
  val wdata = Input(UInt((nDataByte * 8).W))
  val rdata = Output(UInt((nDataByte * 8).W))

  def fromRead(read: CtrlReadIO): Unit = {
    val w_tag = read.addr(nAddrBit - 1, log2Ceil(nDataByte))

    en := read.valid
    wen := 0.U
    addr := read.addr(nAddrBit - 1, log2Ceil(nDataByte))
    wdata := 0.U
  }
  
  def fromWrite(write: CtrlWriteIO): Unit = {
    val w_offset = write.addr(log2Ceil(nDataByte) - 1, 0)
    val w_tag = write.addr(nAddrBit - 1, log2Ceil(nDataByte))

    en := write.valid
    wen := (write.mask << w_offset)
    addr := write.addr(nAddrBit - 1, log2Ceil(nDataByte))
    wdata := (write.data << (w_offset << 3.U))
  }
}

class ByteRamIO (nDataByte: Int, nAddrBit: Int) extends Bundle {
  val en = Input(Bool())
  val wen = Input(Bool())
  val mask = Input(UInt(nDataByte.W))
  val addr = Input(UInt(nAddrBit.W))
  val wdata = Input(UInt((nDataByte * 8).W))
  val rdata = Output(UInt((nDataByte * 8).W))

  def fromRead(read: CtrlReadIO): Unit = {
    en := read.valid
    wen := false.B
    mask := read.mask
    addr := read.addr
    wdata := 0.U
  }

  def fromWrite(write: CtrlWriteIO): Unit = {
    en := write.valid
    wen := true.B
    mask := write.mask
    addr := write.addr
    wdata := write.data
  }
}