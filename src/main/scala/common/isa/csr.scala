/*
 * File: csr.scala                                                             *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-09 01:00:20 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.common.isa.base

import chisel3._
import chisel3.util._


// ******************************
//            ADDRESS
// ******************************
object CSR {
  def CYCLE         = "hc00"
  def TIME          = "hc01"
  def INSTRET       = "hc02"
  def HPMCOUNTER3   = "hc03"
  def HPMCOUNTER4   = "hc04"
  def HPMCOUNTER5   = "hc05"
  def HPMCOUNTER6   = "hc06"
  def HPMCOUNTER7   = "hc07"
  def HPMCOUNTER8   = "hc08"
  def HPMCOUNTER9   = "hc09"
  def HPMCOUNTER10  = "hc0a"
  def HPMCOUNTER11  = "hc0b"
  def HPMCOUNTER12  = "hc0c"
  def HPMCOUNTER13  = "hc0d"
  def HPMCOUNTER14  = "hc0e"
  def HPMCOUNTER15  = "hc0f"
  def HPMCOUNTER16  = "hc10"
  def HPMCOUNTER17  = "hc11"
  def HPMCOUNTER18  = "hc12"
  def HPMCOUNTER19  = "hc13"
  def HPMCOUNTER20  = "hc14"
  def HPMCOUNTER21  = "hc15"
  def HPMCOUNTER22  = "hc16"
  def HPMCOUNTER23  = "hc17"
  def HPMCOUNTER24  = "hc18"
  def HPMCOUNTER25  = "hc19"
  def HPMCOUNTER26  = "hc1a"
  def HPMCOUNTER27  = "hc1b"
  def HPMCOUNTER28  = "hc1c"
  def HPMCOUNTER29  = "hc1d"
  def HPMCOUNTER30  = "hc1e"
  def HPMCOUNTER31  = "hc1f"
  
  def CYCLEH        = "hc80"
  def TIMEH         = "hc81"
  def INSTRETH      = "hc82"
  def HPMCOUNTER3H  = "hc83"
  def HPMCOUNTER4H  = "hc84"
  def HPMCOUNTER5H  = "hc85"
  def HPMCOUNTER6H  = "hc86"
  def HPMCOUNTER7H  = "hc87"
  def HPMCOUNTER8H  = "hc88"
  def HPMCOUNTER9H  = "hc89"
  def HPMCOUNTER10H = "hc8a"
  def HPMCOUNTER11H = "hc8b"
  def HPMCOUNTER12H = "hc8c"
  def HPMCOUNTER13H = "hc8d"
  def HPMCOUNTER14H = "hc8e"
  def HPMCOUNTER15H = "hc8f"
  def HPMCOUNTER16H = "hc90"
  def HPMCOUNTER17H = "hc91"
  def HPMCOUNTER18H = "hc92"
  def HPMCOUNTER19H = "hc93"
  def HPMCOUNTER20H = "hc94"
  def HPMCOUNTER21H = "hc95"
  def HPMCOUNTER22H = "hc96"
  def HPMCOUNTER23H = "hc97"
  def HPMCOUNTER24H = "hc98"
  def HPMCOUNTER25H = "hc99"
  def HPMCOUNTER26H = "hc9a"
  def HPMCOUNTER27H = "hc9b"
  def HPMCOUNTER28H = "hc9c"
  def HPMCOUNTER29H = "hc9d"
  def HPMCOUNTER30H = "hc9e"
  def HPMCOUNTER31H = "hc9f"
}

// ******************************
//           REGISTERS
// ******************************
class CsrBus extends Bundle {
  val cycle         = UInt(64.W)
  val time          = UInt(64.W)
  val instret       = UInt(64.W)
  val hpmcounter3   = UInt(64.W)
  val hpmcounter4   = UInt(64.W)
  val hpmcounter5   = UInt(64.W)
  val hpmcounter6   = UInt(64.W)
  val hpmcounter7   = UInt(64.W)
  val hpmcounter8   = UInt(64.W)
  val hpmcounter9   = UInt(64.W)
  val hpmcounter10  = UInt(64.W)
  val hpmcounter11  = UInt(64.W)
  val hpmcounter12  = UInt(64.W)
  val hpmcounter13  = UInt(64.W)
  val hpmcounter14  = UInt(64.W)
  val hpmcounter15  = UInt(64.W)
  val hpmcounter16  = UInt(64.W)
  val hpmcounter17  = UInt(64.W)
  val hpmcounter18  = UInt(64.W)
  val hpmcounter19  = UInt(64.W)
  val hpmcounter20  = UInt(64.W)
  val hpmcounter21  = UInt(64.W)
  val hpmcounter22  = UInt(64.W)
  val hpmcounter23  = UInt(64.W)
  val hpmcounter24  = UInt(64.W)
  val hpmcounter25  = UInt(64.W)
  val hpmcounter26  = UInt(64.W)
  val hpmcounter27  = UInt(64.W)
  val hpmcounter28  = UInt(64.W)
  val hpmcounter29  = UInt(64.W)
  val hpmcounter30  = UInt(64.W)
  val hpmcounter31  = UInt(64.W)
}