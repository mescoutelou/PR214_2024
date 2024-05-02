/*
 * File: table-ext.scala                                                       *
 * Created Date: 2023-02-25 10:19:59 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-15 11:13:27 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 HerdWare                                                 *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.betizu

import chisel3._
import chisel3.util._

import emmk.common.isa.base.{INSTR => BASE}
import emmk.fpu.{CODE => FPUCODE, OP => FPUOP}

trait TABLEEXT
{
  //                       is Pack ?  Ext unit       Code             S1 ?          S2 ?          S3 ?
  //                           |         |             |               |             |             |
  val default: List[UInt] =          
               List[UInt](    0.B,    EXT.NONE,       0.U,            0.U,          0.U,          0.U)
  val table: Array[(BitPat, List[UInt])]
}

object TABLEEXT32I extends TABLEEXT {
  val table : Array[(BitPat, List[UInt])] =    
              Array[(BitPat, List[UInt])](
  //                       is Pack ?  Ext unit       Code             S1 ?          S2 ?          S3 ?
  //                           |         |             |               |             |             |
    BASE.ADD        -> List(  0.B,   EXT.NONE,       0.U,             0.U,          0.U,          0.U))
}

object TABLEEXT32F extends TABLEEXT {
  val table : Array[(BitPat, List[UInt])] =    
              Array[(BitPat, List[UInt])](
  //                       is Pack ?  Ext unit       Code             S1 ?          S2 ?          S3 ?
  //                           |         |             |               |             |             |
    BASE.FLW        -> List(  0.B,   EXT.FPU,        FPUCODE.FLW,     FPUOP.INT,    0.U,          FPUOP.INT),
    BASE.FSW        -> List(  0.B,   EXT.FPU,        FPUCODE.FSW,     FPUOP.INT,    FPUOP.FLOAT,  FPUOP.INT),
    BASE.FADDS      -> List(  1.B,   EXT.FPU,        FPUCODE.ADD,     FPUOP.FLOAT,  FPUOP.FLOAT,  0.U),
    BASE.FSUBS      -> List(  1.B,   EXT.FPU,        FPUCODE.SUB,     FPUOP.FLOAT,  FPUOP.FLOAT,  0.U),
    BASE.FMINS      -> List(  1.B,   EXT.FPU,        FPUCODE.MIN,     FPUOP.FLOAT,  FPUOP.FLOAT,  0.U),
    BASE.FMAXS      -> List(  1.B,   EXT.FPU,        FPUCODE.MAX,     FPUOP.FLOAT,  FPUOP.FLOAT,  0.U),
    BASE.FMVXW      -> List(  0.B,   EXT.FPU,        FPUCODE.MVXW,    FPUOP.FLOAT,  0.U,          0.U),
    BASE.FMVWX      -> List(  0.B,   EXT.FPU,        FPUCODE.MVWX,    FPUOP.INT,    0.U,          0.U))
}
