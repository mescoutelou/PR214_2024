/*
 * File: bus.scala                                                             *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-09 11:01:39 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.sys

import chisel3._
import chisel3.util._


// ******************************
//           SIMULATION
// ******************************
class SysSimBus(p: SysParams) extends Bundle {
	val gpr = Vec(32, UInt(32.W))
	val fpr = if (p.useFpu) Some(Vec(32, UInt(32.W))) else None
}
