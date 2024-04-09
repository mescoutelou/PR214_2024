/*
 * File: bus.scala                                                             *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-08 10:21:42 am                                       *
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


// ******************************
//             REQ
// ******************************
class MBusReqBus(p: MBusReqParams) extends Bundle {  
  val rw = Bool()
  val size = UInt(SIZE.NBIT.W)
  val addr = UInt(p.nAddrBit.W)
}

class MBusReqIO(p: MBusReqParams) extends Bundle {
  val ready = Input(Bool())
  val valid = Output(Bool())
  val ctrl = Output(new MBusReqBus(p))
}

// ******************************
//             ACK
// ******************************
class MBusDataIO(p: MBusDataParams) extends Bundle {
  val ready = Input(Bool())
  val valid = Output(Bool())
  val data = Output(UInt((p.nDataByte * 8).W))
}

class MBusAckIO(p: MBusDataParams) extends Bundle {
  val write = new MBusDataIO(p)
  val read = Flipped(new MBusDataIO(p))
}

// ******************************
//             FULL
// ******************************
class MBusIO(p: MBusParams) extends Bundle {
  val req = new MBusReqIO(p)
  val write = new MBusDataIO(p)
  val read = Flipped(new MBusDataIO(p))
}

// ******************************
//            MODULES
// ******************************
class MBusNodeBus(nInst: Int) extends Bundle {
  val rw = Bool()
  val size = UInt(SIZE.NBIT.W)
  val zero = Bool()
  val node = UInt(nInst.W)
}