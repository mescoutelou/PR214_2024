/*
 * File: consts.scala                                                          *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 08:12:37 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2023 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.fpu

import chisel3._
import chisel3.util._


// ******************************
//            DECODING
// ******************************
object CODE {
  def NBIT    = 5

	def X				= 0.U(NBIT.W)
	def ADD			= 1.U(NBIT.W)
}

object OP {
  def NBIT    = 2
	def X				= 0.U(NBIT.W)

	def INT			= 1.U(NBIT.W)
	def FLOAT		= 2.U(NBIT.W)
}

// ******************************
//            NUMBERS            
// ******************************
object NAN {
	def INFP(p: FloatParams): FloatBus = {
		val nan = Wire(new FloatBus(p))

		nan.sign := 0.B
		nan.exponent := Cat(Fill(8, 1.B))
		nan.mantissa := Cat(Fill(23, 0.B))

		return nan
	}
	def INFN(p: FloatParams): FloatBus = {
		val nan = Wire(new FloatBus(p))

		nan.sign := 1.B
		nan.exponent := Cat(Fill(8, 1.B))
		nan.mantissa := Cat(Fill(23, 0.B))

		return nan
	}
	def NANF(p: FloatParams): FloatBus = {
		val nan = Wire(new FloatBus(p))

		nan.sign := 0.B
		nan.exponent := Cat(Fill(8, 1.B))
		nan.mantissa := Cat(Fill(22, 0.B), 1.B)

		return nan
	}
	def NANQ(p: FloatParams): FloatBus = {
		val nan = Wire(new FloatBus(p))

		nan.sign := 0.B
		nan.exponent := Cat(Fill(8, 1.B))
		nan.mantissa := Cat(1.B, Fill(22, 0.B))

		return nan
	}
	def NANC(p: FloatParams): FloatBus = NANQ(p)

	def isInf(p: FloatParams, value: FloatBus): Bool = {
		val nan = Wire(Bool())
		when (value === INFP(p)) {
			nan := true.B
		}.elsewhen (value === INFN(p)) {
			nan := true.B
		}.otherwise {
			nan := false.B
		}
		return nan
	}

	def isNaN(p: FloatParams, value: FloatBus): Bool = {
		val nan = Wire(Bool())
		when (value === INFP(p)) {
			nan := true.B
		}.elsewhen (value === INFN(p)) {
			nan := true.B
		}.elsewhen (value === NANF(p)) {
			nan := true.B
		}.elsewhen (value === NANQ(p)) {
			nan := true.B
		}.otherwise {
			nan := false.B
		}
		return nan
	}
}