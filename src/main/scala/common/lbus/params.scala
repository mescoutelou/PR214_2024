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


package emmk.common.lbus

import chisel3._
import chisel3.util._
import scala.math._

import emmk.common.gen._
import emmk.common.mbus._


trait LBusParams  {
  def isSim: Boolean  

  def readOnly: Boolean
  def nAddrBit: Int
  def nDataByte: Int
  def nDataBit: Int = nDataByte * 8
}

case class LBusConfig (
  isSim: Boolean,  

  readOnly: Boolean,
  nAddrBit: Int,
  nDataByte: Int
) extends LBusParams


trait LBusMBusParams extends GenParams  {
  def pLBus: LBusParams

  def isSim: Boolean = pLBus.isSim

  def readOnly: Boolean = pLBus.readOnly
  def nAddrBit: Int = pLBus.nAddrBit
  def nDataByte: Int = pLBus.nDataByte
  def nDataBit: Int = nDataByte * 8

  def nRBufferDepth: Int
  def nWBufferDepth: Int

  def pMBus: MBusParams = new MBusConfig(
    isSim = pLBus.isSim,  

    readOnly = pLBus.readOnly,
    nAddrBit = pLBus.nAddrBit,
    nDataByte = pLBus.nDataByte
  )
}

case class LBusMBusConfig (
  pLBus: LBusParams,
  nRBufferDepth: Int,
  nWBufferDepth: Int
) extends LBusMBusParams