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


package prj.common.gen

import chisel3._
import chisel3.util._


// ******************************
//          GENERIC BUS
// ******************************
class GenBus[TC <: Data, TD <: Data](p: GenParams, tc: TC, td: TD) extends Bundle {
  val ctrl = if (tc.getWidth > 0) Some(tc) else None
  val data = if (td.getWidth > 0) Some(td) else None
}

class GenVBus[TC <: Data, TD <: Data](p: GenParams, tc: TC, td: TD) extends GenBus[TC, TD](p, tc, td) {
  val valid = Bool()
}

class GenRVBus[TC <: Data, TD <: Data](p: GenParams, tc: TC, td: TD) extends GenVBus[TC, TD](p, tc, td) {
  val ready = Bool()
}

// ******************************
//           GENERIC IO
// ******************************
class GenIO[TC <: Data, TD <: Data](p: GenParams, tc: TC, td: TD) extends Bundle {
  val ctrl = if (tc.getWidth > 0) Some(Output(tc)) else None
  val data = if (td.getWidth > 0) Some(Output(td)) else None
}
class GenVIO[TC <: Data, TD <: Data](p: GenParams, tc: TC, td: TD) extends GenIO[TC, TD](p, tc, td) {
  val valid = Output(Bool())
}

class GenRVIO[TC <: Data, TD <: Data](p: GenParams, tc: TC, td: TD) extends GenVIO[TC, TD](p, tc, td) {
  val ready = Input(Bool())
}