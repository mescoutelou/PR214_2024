/*
 * File: consts.scala                                                          *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-08 10:22:15 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.common.isa.base

import chisel3._
import chisel3.util._


// ******************************
//            REGISTERS
// ******************************
object REG {
  // ------------------------------
  //              GPR
  // ------------------------------
  val X0 = "b00000"
  val X1 = "b00001"
  val X5 = "b00101"
}
