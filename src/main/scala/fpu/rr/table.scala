/*
 * File: table.scala                                                           *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 02:44:45 pm                                       *
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


object TABLECODE {
  //                                   Valid    Uop      WB
  //                                     |       |       |
  val default: List[UInt] = List[UInt]( 0.B,  UOP.X,    0.B)
  val table: Array[(BitPat, List[UInt])] = Array[(BitPat, List[UInt])] (
    BitPat(CODE.ADD)          -> List(  1.B,  UOP.ADD,  1.B),
    BitPat(CODE.SUB)          -> List(  1.B,  UOP.SUB,  1.B)
  )
}