/*
 * File: params.scala                                                          *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 12:24:46 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.fpu

import chisel3._
import chisel3.util._

import prj.common.gen._
import prj.common.mbus._


trait FloatParams {
	def isSim: Boolean

	def nDataBit: Int = 32
	def nDataByte: Int = (nDataBit / 8).toInt

	def nExponentBit: Int = 8
	def nMantissaBit: Int = 23
}

trait FpuParams extends GenParams
									with FloatParams {
	def isSim: Boolean

	def nAddrBit: Int

	def useShiftStage: Boolean
	def useExStage: Boolean
	def nBypass: Int = 0

  def pDBus: MBusParams = new MBusConfig (
    isSim = isSim,

    readOnly = false,
    nAddrBit = nAddrBit,
    nDataByte = nDataByte
  )
}

case class FpuConfig (
	isSim: Boolean, 
	
	nAddrBit: Int,

	useShiftStage: Boolean,
	useExStage: Boolean
) extends FpuParams
