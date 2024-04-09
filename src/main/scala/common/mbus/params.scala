/*
 * File: params.scala                                                          *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 12:14:40 pm                                       *
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
import scala.math._

import emmk.common.gen._


// ******************************
//              BASE
// ******************************
trait MBusBaseParams extends GenParams {
  def isSim: Boolean
}

case class MBusBaseConfig (
  isSim: Boolean
) extends MBusBaseParams

// ******************************
//              REQ
// ******************************
trait MBusReqParams extends MBusBaseParams {
  def isSim: Boolean  

  def readOnly: Boolean
  def nAddrBit: Int
}

case class MBusReqConfig (
  isSim: Boolean,  

  readOnly: Boolean,
  nAddrBit: Int
) extends MBusReqParams

// ******************************
//             DATA
// ******************************
trait MBusDataParams extends MBusBaseParams {
  def isSim: Boolean  

  def readOnly: Boolean
  def nDataByte: Int
  def nDataBit: Int = nDataByte * 8
}

case class MBusDataConfig (
  isSim: Boolean,  

  readOnly: Boolean,
  nHart: Int,
  nDataByte: Int
) extends MBusDataParams

// ******************************
//              BUS
// ******************************
trait MBusParams extends MBusReqParams with MBusDataParams {
  def isSim: Boolean  

  def readOnly: Boolean
  def nAddrBit: Int
  def nDataByte: Int
}

case class MBusConfig (
  isSim: Boolean,  

  readOnly: Boolean,
  nAddrBit: Int,
  nDataByte: Int
) extends MBusParams

// ******************************
//              BUS
// ******************************

// ******************************
//            MEMORY
// ******************************
trait MBusMemParams {
  def pPort: Array[MBusParams]

  def nAddrBase: String
  def nByte: String
}

case class MBusMemConfig (
  pPort: Array[MBusParams],
  
  nAddrBase: String,
  nByte: String
) extends MBusMemParams

// ******************************
//          INTERCONNECT
// ******************************
trait MBusCrossbarParams extends GenParams {
  def pMaster: Array[MBusParams]
  def nMaster: Int = pMaster.size

  def useMem: Boolean
  def pMem: Array[MBusMemParams]
  def nMem: Int = pMem.size
  def nDefault: Int 
  def nBus: Int
  def useDirect: Boolean
  def nSlave: Int = {
    if (useMem) {
      return nMem + nDefault
    } else {
      return nBus
    }
  }
  def pSlave: MBusParams = MBUS.node(pMaster)
  
  def isSim: Boolean  

  def readOnly: Boolean = pSlave.readOnly
  def nAddrBit: Int = pSlave.nAddrBit
  def nDataByte: Int = pSlave.nDataByte
  def nDataBit: Int = nDataByte * 8

  def nDepth: Int
}

case class MBusCrossbarConfig (
  pMaster: Array[MBusParams],
  useMem: Boolean,
  pMem: Array[MBusMemParams],
  nDefault: Int,
  nBus: Int,
  
  isSim: Boolean,  
  
  nDepth: Int,
  useDirect: Boolean
) extends MBusCrossbarParams
