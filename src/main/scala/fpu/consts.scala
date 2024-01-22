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