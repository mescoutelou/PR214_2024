/*
 * File: example.scala                                                         *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2023-12-21 07:27:31 am                                       *
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


class FpuReqCtrlBus extends Bundle {
	val code = UInt(CODE.NBIT.W)
	val op1 = UInt(OP.NBIT.W)
	val op2 = UInt(OP.NBIT.W)
	val op3 = UInt(OP.NBIT.W)
	val wb = Bool()
}

class FpuReqDataBus (nDataBit: Int) extends Bundle {
	val s1 = UInt(nDataBit.W)
	val s2 = UInt(nDataBit.W)
	val s3 = UInt(nDataBit.W)
}