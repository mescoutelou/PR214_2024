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

// ******************************
//          CONTROL BUS            
// ******************************
class InfoBus(p: FpuParams) extends Bundle {
	val wb = Bool()
}

class ExBus(p: FpuParams) extends Bundle {
	val uop = UInt(UOP.NBIT.W)
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
class DataBus(p: FpuParams) extends Bundle {
	val src = Vec(3, new FloatBus(p))
}

class ResultBus(p: FpuParams) extends Bundle {
	val res = new FloatBus(p)
}