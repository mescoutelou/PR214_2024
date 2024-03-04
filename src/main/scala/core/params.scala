/*
 * File: params.scala                                                          *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 02:31:06 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.core

import chisel3._
import chisel3.util._

import prj.common.mbus._
import prj.common.lbus._


trait CoreParams {
	def isSim: Boolean

	def nAddrBit: Int
	def nDataBit: Int = 32
	def nDataByte: Int = (nDataBit / 8).toInt

  def pILBus: LBusParams = new LBusConfig (
    isSim = isSim,

    readOnly = true,
    nAddrBit = nAddrBit,
    nDataByte = nDataByte
  )

  def pILBusMBus: LBusMBusParams = new LBusMBusConfig (
    pLBus = pILBus,
    nRBufferDepth = 0,
    nWBufferDepth = 0
  )

  def pIBus: MBusParams = pILBusMBus.pMBus

  def pDBus: MBusParams = new MBusConfig (
    isSim = isSim,

    readOnly = false,
    nAddrBit = nAddrBit,
    nDataByte = nDataByte
  )
}

case class CoreConfig (
	isSim: Boolean, 
	
	nAddrBit: Int
) extends CoreParams
