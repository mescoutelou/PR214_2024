/*
 * File: params.scala                                                          *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-02-06 10:43:08 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.fpu

import chisel3._
import chisel3.util._

import emmk.common.gen._
import emmk.common.mbus._


trait FpuParams extends GenParams {
	def isSim: Boolean

	def nAddrBit: Int
	def nDataBit: Int = 32
	def nDataByte: Int = (nDataBit / 8).toInt
	def nExponentBit: Int = 8
	def nMantissaBit: Int = 23

	def useShiftStage: Boolean
	def useExStage: Boolean
	def nBypass: Int = {
		var nbyp: Int = 1

		if (useShiftStage) nbyp = nbyp + 1
		if (useExStage) nbyp = nbyp + 1

		return nbyp
	}

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
