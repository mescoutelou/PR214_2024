/*
 * File: consts.scala                                                          *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-02-06 12:09:39 pm                                       *
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


// ******************************
//            DECODING
// ******************************
object CODE {
  def NBIT    = 4

	def X				= 0.U(NBIT.W)
	def ADD			= 1.U(NBIT.W)
	def SUB			= 2.U(NBIT.W)
	def MIN			= 3.U(NBIT.W)
	def MAX			= 4.U(NBIT.W)
	def MVWX		= 5.U(NBIT.W)

	def EQ 			= 8.U(NBIT.W)
	def LT 			= 9.U(NBIT.W)
	def LE 			= 10.U(NBIT.W)
	def CLASS 	= 11.U(NBIT.W)

	def FCVTSW	= 15.U(NBIT.W)
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
	def ZEROP(nExponentBit: Int, nMantissaBit: Int): FloatBus = {
		val nan = Wire(new FloatBus(nExponentBit, nMantissaBit))

		nan.sign := 0.B
		nan.expo := 0.U
		nan.mant := 0.U

		return nan
	}
	def ZERON(nExponentBit: Int, nMantissaBit: Int): FloatBus = {
		val nan = Wire(new FloatBus(nExponentBit, nMantissaBit))

		nan.sign := 1.B
		nan.expo := 0.U
		nan.mant := 0.U

		return nan
	}

	def INFP(nExponentBit: Int, nMantissaBit: Int): FloatBus = {
		val nan = Wire(new FloatBus(nExponentBit, nMantissaBit))

		nan.sign := 0.B
		nan.expo := Cat(Fill(nExponentBit, 1.B))
		nan.mant := Cat(Fill(nMantissaBit, 0.B))

		return nan
	}
	def INFN(nExponentBit: Int, nMantissaBit: Int): FloatBus = {
		val nan = Wire(new FloatBus(nExponentBit, nMantissaBit))

		nan.sign := 1.B
		nan.expo := Cat(Fill(nExponentBit, 1.B))
		nan.mant := Cat(Fill(nMantissaBit, 0.B))

		return nan
	}
	def NANF(nExponentBit: Int, nMantissaBit: Int): FloatBus = {
		val nan = Wire(new FloatBus(nExponentBit, nMantissaBit))

		nan.sign := 0.B
		nan.expo := Cat(Fill(nExponentBit, 1.B))
		nan.mant := Cat(Fill(nMantissaBit - 1, 0.B), 1.B)

		return nan
	}
	def NANQ(nExponentBit: Int, nMantissaBit: Int): FloatBus = {
		val nan = Wire(new FloatBus(nExponentBit, nMantissaBit))

		nan.sign := 0.B
		nan.expo := Cat(Fill(nExponentBit, 1.B))
		nan.mant := Cat(1.B, Fill(nMantissaBit - 1, 0.B))

		return nan
	}
	def NANC(nExponentBit: Int, nMantissaBit: Int): FloatBus = NANQ(nExponentBit, nMantissaBit)

	def isInf(nExponentBit: Int, nMantissaBit: Int, value: FloatBus): Bool = {
		val nan = Wire(Bool())
		when (value === INFP(nExponentBit, nMantissaBit)) {
			nan := true.B
		}.elsewhen (value === INFN(nExponentBit, nMantissaBit)) {
			nan := true.B
		}.otherwise {
			nan := false.B
		}
		return nan
	}

	def isNaN(nExponentBit: Int, nMantissaBit: Int, value: FloatBus): Bool = {
		val nan = Wire(Bool())
		when (value === INFP(nExponentBit, nMantissaBit)) {
			nan := true.B
		}.elsewhen (value === INFN(nExponentBit, nMantissaBit)) {
			nan := true.B
		}.elsewhen (value === NANF(nExponentBit, nMantissaBit)) {
			nan := true.B
		}.elsewhen (value === NANQ(nExponentBit, nMantissaBit)) {
			nan := true.B
		}.otherwise {
			nan := false.B
		}
		return nan
	}
}

// ******************************
//            MICRO-OP            
// ******************************
object UOP {
	def NBIT 	= 4
	def X			= 0.U(NBIT.W)

	def MV		= 1.U(NBIT.W)
	def ADD		= 2.U(NBIT.W)
	def SUB		= 3.U(NBIT.W)
	def MIN		= 4.U(NBIT.W)
	def MAX		= 5.U(NBIT.W)
	def EQ		= 6.U(NBIT.W)
	def LT		= 7.U(NBIT.W)
	def LE		= 8.U(NBIT.W)
	def CLASS = 9.U(NBIT.W)
}