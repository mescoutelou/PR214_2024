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
  //                                   Valid    Uop        WB   Int
  //                                     |       |         |     |
  val default: List[UInt] = List[UInt]( 0.B,  UOP.X,      0.B,  0.B)
  val table: Array[(BitPat, List[UInt])] = Array[(BitPat, List[UInt])] (
    BitPat(CODE.MVWX)         -> List(  1.B,  UOP.MV,     1.B,  0.B),
    BitPat(CODE.ADD)          -> List(  1.B,  UOP.ADD,    1.B,  0.B),
    BitPat(CODE.SUB)          -> List(  1.B,  UOP.SUB,    1.B,  0.B),
    BitPat(CODE.MIN)          -> List(  1.B,  UOP.MIN,    1.B,  0.B),
    BitPat(CODE.MAX)          -> List(  1.B,  UOP.MAX,    1.B,  0.B),
    BitPat(CODE.EQ)           -> List(  1.B,  UOP.EQ,     0.B,  1.B),
    BitPat(CODE.LT)           -> List(  1.B,  UOP.LT,     0.B,  1.B),
    BitPat(CODE.LE)           -> List(  1.B,  UOP.LE,     0.B,  1.B),
    BitPat(CODE.CLASS)        -> List(  1.B,  UOP.CLASS,  0.B,  1.B)
  )
}