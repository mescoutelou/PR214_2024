/*
 * File: params.scala                                                          *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 08:48:45 am                                       *
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


trait FloatParams {
	def isSim: Boolean

	def nDataBit: Int = 32

	def nExponentBit: Int = 8
	def nMantissaBit: Int = 23
}

trait FpuParams extends FloatParams {
	def isSim: Boolean

	def nAddrBit: Int
	def nBypass: Int = 2
}

case class FpuConfig (
	isSim: Boolean, 
	
	nAddrBit: Int
) extends FpuParams
