/*
 * File: table-lsu.scala                                                       *
 * Created Date: 2023-02-25 10:19:59 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-08 11:03:03 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.betizu

import chisel3._
import chisel3.util._

import emmk.common.isa.base.{INSTR => BASE}


// ************************************************************
//
//        DECODE TABLES TO EXTRACT MEMORY INFORMATION
//
// ************************************************************
trait TABLELSU {
  //                                    Uop                        use sign ?  
  //                                     |            Size            |        
  //                        use LSU ?    |              |             |        
  //                           |         |              |             |        
  val default: List[UInt] =
               List[UInt](    0.B,    LSUUOP.X,     LSUSIZE.X,    LSUSIGN.X )
  val table: Array[(BitPat, List[UInt])]
}

object TABLELSU32I extends TABLELSU {
  val table : Array[(BitPat, List[UInt])] =
              Array[(BitPat, List[UInt])](

  //                                    Uop                        use sign ?  
  //                                     |            Size            |        
  //                        use LSU ?    |              |             |        
  //                           |         |              |             |        
  BASE.LB         -> List(    1.B,    LSUUOP.R,     LSUSIZE.B,    LSUSIGN.S ),
  BASE.LH         -> List(    1.B,    LSUUOP.R,     LSUSIZE.H,    LSUSIGN.S ),
  BASE.LW         -> List(    1.B,    LSUUOP.R,     LSUSIZE.W,    LSUSIGN.S ),
  BASE.LBU        -> List(    1.B,    LSUUOP.R,     LSUSIZE.B,    LSUSIGN.U ),
  BASE.LHU        -> List(    1.B,    LSUUOP.R,     LSUSIZE.H,    LSUSIGN.U ),
  BASE.SB         -> List(    1.B,    LSUUOP.W,     LSUSIZE.B,    LSUSIGN.S ),
  BASE.SH         -> List(    1.B,    LSUUOP.W,     LSUSIZE.H,    LSUSIGN.S ),
  BASE.SW         -> List(    1.B,    LSUUOP.W,     LSUSIZE.W,    LSUSIGN.S ))
}
