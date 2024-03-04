/*
 * File: bus.scala                                                             *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 12:14:21 pm                                       *
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

import prj.common.mbus._


class LBusCtrlBus(p: LBusParams) extends Bundle {  
  val rw = Bool()
  val size = UInt(SIZE.NBIT.W)
  val addr = UInt(p.nAddrBit.W)
}

class LBusIO(p: LBusParams) extends Bundle {
  val ready = Input(Bool())
  val valid = Output(Bool())
  val ctrl = Output(new LBusCtrlBus(p))
  val wdata = Output(UInt((p.nDataByte * 8).W))
  val rdata = Input(UInt((p.nDataByte * 8).W))
}