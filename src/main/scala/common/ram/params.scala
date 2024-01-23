/*
 * File: params.scala                                                          *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 01:41:49 pm                                       *
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
import scala.math._

import prj.common.gen._
import prj.common.mbus.{MBusParams, MBusMemParams, MBusConfig}


trait RamCtrlParams extends GenParams {
  def nPort: Int

  def isSim: Boolean

  def isRom: Boolean
  def nByte: String
  def nDataByte: Int
  def nData: Int = (BigInt(nByte, 16) / nDataByte).toInt
  def nAddrBit: Int = log2Ceil(BigInt(nByte, 16))
}

case class RamCtrlConfig (
  nPort: Int,

  isSim: Boolean,

  isRom: Boolean,
  nByte: String,
  nDataByte: Int
) extends RamCtrlParams

trait MBusCtrlParams extends GenParams {
  def pPort: MBusParams

  def isSim: Boolean

  def isRom: Boolean
  def readOnly: Boolean = pPort.readOnly
  def nAddrBit: Int = pPort.nAddrBit
  def nDataByte: Int = pPort.nDataByte

  def useReqReg: Boolean
}

case class MBusCtrlConfig (
  pPort: MBusParams,  

  isSim: Boolean,

  isRom: Boolean,
  useReqReg: Boolean
) extends MBusCtrlParams

trait MBusRamParams extends RamCtrlParams with MBusMemParams {
  def pPort: Array[MBusParams]
  def nPort: Int = pPort.size

  def isSim: Boolean

  def initFile: String
  def isRom: Boolean
  def nAddrBase: String
  def nByte: String
  def nDataByte: Int = {
    var nbyte: Int = 0
    for (po <- pPort) {
      nbyte = max(nbyte, po.nDataByte)
    }
    return nbyte
  }
  def nDataBit: Int = nDataByte * 8
  
  def useReqReg: Boolean

  def pCtrl: Array[MBusCtrlParams] = {    
    var p = new Array[MBusCtrlParams](nPort)
    for (port <- 0 until nPort) {
      p(port) = new MBusCtrlConfig (
        pPort = pPort(port),

        isSim = isSim,

        isRom = isRom,
        useReqReg = useReqReg
      )
    }
    return p
  }
}

case class MBusRamConfig (
  pPort: Array[MBusParams],
  
  isSim: Boolean,

  initFile: String,
  isRom: Boolean,
  nAddrBase: String,
  nByte: String,
  useReqReg: Boolean
) extends MBusRamParams