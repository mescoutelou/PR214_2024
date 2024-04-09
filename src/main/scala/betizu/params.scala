/*
 * File: params.scala                                                          *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-09 11:02:39 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.betizu

import chisel3._
import chisel3.util._
import scala.math._

import prj.common.gen._
import prj.common.lbus._
import prj.common.mbus._


trait BetizuParams extends GenParams {
  def isSim: Boolean  

  def pcBoot: String
  
  def nInstrBit: Int = 32
  def nInstrByte: Int = (nInstrBit / 8).toInt
  def nAddrBit: Int = 32
  def nDataBit: Int = 32
  def nDataByte: Int = (nDataBit / 8).toInt

  def pFetchBus: LBusParams = new LBusConfig (
    isSim = isSim,  

    readOnly = true,
    nAddrBit = nAddrBit,
    nDataByte = nInstrByte
  )

  def pL0IBuffer: LBusMBusParams = new LBusMBusConfig (
    pLBus= pFetchBus,
    nRBufferDepth = 0,
    nWBufferDepth = 0
  )

  def pL0IBus: MBusParams = pL0IBuffer.pMBus

  def useL0IBuffer: Boolean = true
  def nL0IBufferDepth: Int = 2
  def useIfStage: Boolean
  def useIdStage: Boolean = false
  def nExBufferDepth: Int = 2
  def useFpu: Boolean
  def useGprBypass: Boolean = true
  def nGprBypass: Int = {
    if (useIdStage) {
      return nExBufferDepth + 1
    } else {
      return nExBufferDepth + 0
    }
  }

  def pLsuBus: LBusParams = new LBusConfig (
    isSim = isSim,  

    readOnly = false,
    nAddrBit = nAddrBit,
    nDataByte = nDataByte
  )

  def pL0DBuffer: LBusMBusParams = new LBusMBusConfig (
    pLBus= pLsuBus,
    nRBufferDepth = 0,
    nWBufferDepth = 0
  )

  def pL0DBus: MBusParams = pL0DBuffer.pMBus
}

case class BetizuConfig (
  isSim: Boolean, 

  pcBoot: String,

  useIfStage: Boolean,
  useFpu: Boolean
) extends BetizuParams
