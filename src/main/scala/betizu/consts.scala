/*
 * File: consts.scala                                                          *
 * Created Date: 2023-02-25 10:19:59 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-09 01:33:35 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.betizu

import chisel3._


// ******************************
//            DECODING
// ******************************
// ------------------------------
//            OPERAND
// ------------------------------
object OP {
  def NBIT    = 3
  def X       = 0.U(NBIT.W)
  
  def PC      = 1.U(NBIT.W)
  def INSTR   = 2.U(NBIT.W)
  def IMM1    = 3.U(NBIT.W)
  def IMM2    = 4.U(NBIT.W)
  def XREG    = 5.U(NBIT.W)
}

// ------------------------------
//            IMMEDIATE
// ------------------------------
object IMM {
  def NBIT  = 4
  def X     = 0.U(NBIT.W)

  def is0   = 0.U(NBIT.W)
  def isR   = 1.U(NBIT.W)
  def isI   = 2.U(NBIT.W)
  def isS   = 3.U(NBIT.W)
  def isB   = 4.U(NBIT.W)
  def isU   = 5.U(NBIT.W)
  def isJ   = 6.U(NBIT.W)
  def isC   = 7.U(NBIT.W)
  def isV   = 8.U(NBIT.W)
  def isZ   = 9.U(NBIT.W)
}

// ******************************
//            INTEGER
// ******************************
object INTUNIT {
  def NBIT    = 2

  def X       = 0.U(NBIT.W)
  def ALU     = 1.U(NBIT.W)
  def BRU     = 2.U(NBIT.W)
  def CSR     = 3.U(NBIT.W)
}

object INTUOP {
  def NBIT        = 5
  def X           = 0.U(NBIT.W)

  // ------------------------------
  //              ALU
  // ------------------------------
  def ADD         = 1.U(NBIT.W)
  def SUB         = 2.U(NBIT.W)
  def SLT         = 3.U(NBIT.W)
  def OR          = 4.U(NBIT.W)
  def AND         = 5.U(NBIT.W)
  def XOR         = 6.U(NBIT.W)
  def SHR         = 7.U(NBIT.W)
  def SHL         = 8.U(NBIT.W)

  // ------------------------------
  //              BRU
  // ------------------------------
  def JAL         = 2.U(NBIT.W)
  def JALR        = 3.U(NBIT.W)

  def FENCE       = 4.U(NBIT.W)

  def BEQ         = 8.U(NBIT.W)
  def BNE         = 9.U(NBIT.W)
  def BLT         = 10.U(NBIT.W)
  def BGE         = 11.U(NBIT.W)
}

// ******************************
//         LOAD-STORE UNIT
// ******************************
object LSUUOP {
  val NBIT  = 1
  val X     = 0.U(NBIT.W)

  val R     = 0.U(NBIT.W)
  val W     = 1.U(NBIT.W)
}

object LSUSIGN {
  val NBIT  = 1
  val X     = 0.U(NBIT.W)

  val U     = 0.U(NBIT.W)
  val S     = 1.U(NBIT.W)
}

object LSUSIZE {
  val NBIT  = 2
  val X     = 0.U(NBIT.W)

  val B     = 0.U(NBIT.W)
  val H     = 1.U(NBIT.W)
  val W     = 2.U(NBIT.W)
  val D     = 3.U(NBIT.W)
}

// ******************************
//            EXTERNAL
// ******************************
object EXT {
  def NBIT  = 2
  def X     = 0.U(NBIT.W)

  def NONE  = 0.U(NBIT.W)
  def FPU   = 1.U(NBIT.W)
}

// ******************************
//          MULTI-CYCLE
// ******************************
object MULTI {
  def NBIT  = 2
  def X     = 0.U(NBIT.W)

  def MEM   = 1.U(NBIT.W)
  def FPU   = 2.U(NBIT.W)
}

// ******************************
//              CSR
// ******************************
object CSRUOP {
  val NBIT  = 3

  val X   = 0.U(NBIT.W)
  val W   = 1.U(NBIT.W)
  val S   = 2.U(NBIT.W)
  val C   = 3.U(NBIT.W)
  val RX  = 4.U(NBIT.W)
  val RW  = 5.U(NBIT.W)
  val RS  = 6.U(NBIT.W)
  val RC  = 7.U(NBIT.W)
}