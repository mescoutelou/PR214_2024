/*
 * File: bus.scala                                                             *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-02-06 03:47:07 pm                                       *
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


// ******************************
//              PORT            
// ******************************
class FpuReqCtrlBus extends Bundle {
	val code = UInt(CODE.NBIT.W)
	val op = Vec(3, UInt(OP.NBIT.W))
	val rs = Vec(3, UInt(5.W))
	val rd = UInt(5.W)
	val wb = Bool()
}

class FpuReqDataBus(nDataBit: Int) extends Bundle {
	val src = Vec(3, UInt(nDataBit.W))
}

class FpuReqIO(p: GenParams, nDataBit: Int) extends GenRVIO(p, new FpuReqCtrlBus(), new FpuReqDataBus(nDataBit))

class FpuAckIO(p: GenParams, nDataBit: Int) extends GenRVIO(p, UInt(0.W), UInt(nDataBit.W))

class FpuIO(p: GenParams, nDataBit: Int) extends Bundle {
	val req = Flipped(new FpuReqIO(p, nDataBit))
	val ack = new FpuAckIO(p, nDataBit)
}

// ******************************
//             FLOAT            
// ******************************
class FloatBus(nExponentBit: Int, nMantissaBit: Int) extends Bundle {
	val sign = Bool()
	val expo = UInt(nExponentBit.W)
	val mant = UInt(nMantissaBit.W)

	def toUInt(): UInt = {
		return Cat(sign, expo, mant)
	}

	def fromUInt(uint: UInt): Unit = {
		sign := uint(nExponentBit + nMantissaBit)
		expo := uint(nMantissaBit + nExponentBit - 1, nMantissaBit)
		mant := uint(nMantissaBit - 1, 0)
	}
}

// ******************************
//              FPR            
// ******************************
class FprReadIO(p: FpuParams) extends Bundle {
	val addr = Input(UInt(5.W))
	val ready = Output(Bool())
	val data = Output(new FloatBus(p.nExponentBit, p.nMantissaBit))
}

class FprWriteIO(p: FpuParams) extends Bundle {
	val valid = Input(Bool())
	val addr = Input(UInt(5.W))
	val data = Input(new FloatBus(p.nExponentBit, p.nMantissaBit))
	val ready = Output(Bool())
}

class BypassBus(p: FpuParams) extends Bundle {
	val valid = Bool()
	val ready = Bool()
	val addr = UInt(5.W)
	val data = new FloatBus(p.nExponentBit, p.nMantissaBit)
}

// ******************************
//          CONTROL BUS            
// ******************************
class InfoBus(p: FpuParams) extends Bundle {
	val wb = Bool()
	val int = Bool()
}

class ExBus(p: FpuParams) extends Bundle {
	val uop = UInt(UOP.NBIT.W)
	val equ = Vec(3, Bool())
	val agreat = Bool()
	val sgreat = Bool()
	val neg = Vec(3, Bool())
}

class FprBus(p: FpuParams) extends Bundle {
	val en = Bool()
	val addr = UInt(5.W)
}

// ******************************
//       STAGE CONTROL BUS            
// ******************************
class ShiftCtrlBus(p: FpuParams) extends Bundle {
	val info = new InfoBus(p)

	val ex = new ExBus(p)
	val fpr = new FprBus(p)
}

class ExCtrlBus(p: FpuParams) extends Bundle {
	val info = new InfoBus(p)

	val ex = new ExBus(p)
	val fpr = new FprBus(p)
}

class WbCtrlBus(p: FpuParams) extends Bundle {
	val info = new InfoBus(p)

	val fpr = new FprBus(p)
}

// ******************************
//            DATA BUS            
// ******************************
class SourceBus(p: FpuParams) extends Bundle {
	val src = Vec(3, new FloatBus(p.nExponentBit, p.nMantissaBit))
}

class OperandBus(p: FpuParams) extends Bundle {
	val src = Vec(3, new FloatBus(p.nExponentBit, p.nMantissaBit + 1))
}

class ResultBus(p: FpuParams) extends Bundle {
	val res = new FloatBus(p.nExponentBit, p.nMantissaBit * 2)
}