/*
 * File: bus.scala                                                             *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 08:48:21 am                                       *
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


// ******************************
//              PORT            
// ******************************
class FpuReqCtrlBus extends Bundle {
	val code = UInt(CODE.NBIT.W)
	val op1 = UInt(OP.NBIT.W)
	val op2 = UInt(OP.NBIT.W)
	val op3 = UInt(OP.NBIT.W)
	val wb = Bool()
}

class FpuReqDataBus(nDataBit: Int) extends Bundle {
	val s1 = UInt(nDataBit.W)
	val s2 = UInt(nDataBit.W)
	val s3 = UInt(nDataBit.W)
}

// ******************************
//             FLOAT            
// ******************************
class FloatBus(p: FloatParams) extends Bundle {
	val sign = Bool()
	val exponent = UInt(p.nExponentBit.W)
	val mantissa = UInt(p.nMantissaBit.W)

	def toUInt(): UInt = {
		return Cat(sign, exponent, mantissa)
	}

	def fromUInt(uint: UInt): Unit = {
		sign := uint(p.nExponentBit + p.nMantissaBit)
		exponent := uint(p.nMantissaBit + p.nExponentBit - 1, p.nMantissaBit)
		mantissa := uint(p.nMantissaBit - 1, 0)
	}
}

// ******************************
//              FPR            
// ******************************
class FprReadIO(p: FpuParams) extends Bundle {
	val addr = Input(UInt(5.W))
	val ready = Output(Bool())
	val data = Output(new FloatBus(p))
}

class FprWriteIO(p: FpuParams) extends Bundle {
	val valid = Input(Bool())
	val addr = Input(UInt(5.W))
	val data = Input(new FloatBus(p))
	val ready = Output(Bool())
}

class BypassBus(p: FpuParams) extends Bundle {
	val valid = Bool()
	val ready = Bool()
	val addr = UInt(5.W)
	val data = new FloatBus(p)
}