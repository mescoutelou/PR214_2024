/*
 * File: table-ext.scala                                                       *
 * Created Date: 2023-02-25 10:19:59 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-08 10:54:40 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.betizu

import chisel3._
import chisel3.util._

import prj.common.isa.base.{INSTR => BASE}

trait TABLEEXT
{
  //                          Ext unit       Code             S1 ?          S2 ?          S3 ?
  //                             |             |               |             |             |
  val default: List[UInt] =
               List[UInt](    EXT.NONE,       0.U,            0.U,          0.U,          0.U)
  val table: Array[(BitPat, List[UInt])]
}

object TABLEEXT32I extends TABLEEXT {
  val table : Array[(BitPat, List[UInt])] =    
              Array[(BitPat, List[UInt])](
  //                          Ext unit       Code             S1 ?          S2 ?          S3 ?
  //                             |             |               |             |             |
    BASE.ADD        -> List(  EXT.NONE,       0.U,            0.U,          0.U,          0.U))
}
