/*
 * File: instr.scala                                                           *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-09 01:45:32 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.common.isa.base

import chisel3._
import chisel3.util._


object INSTR {
  // ******************************
  //            RV32I
  // ******************************
  def LUI       = BitPat("b?????????????????????????0110111")
  def AUIPC     = BitPat("b?????????????????????????0010111")
  def JAL       = BitPat("b?????????????????????????1101111")
  def JALR      = BitPat("b?????????????????000?????1100111")
  def BEQ       = BitPat("b?????????????????000?????1100011")
  def BNE       = BitPat("b?????????????????001?????1100011")
  def BLT       = BitPat("b?????????????????100?????1100011")
  def BGE       = BitPat("b?????????????????101?????1100011")
  def BLTU      = BitPat("b?????????????????110?????1100011")
  def BGEU      = BitPat("b?????????????????111?????1100011")
  def LB        = BitPat("b?????????????????000?????0000011")
  def LH        = BitPat("b?????????????????001?????0000011")
  def LW        = BitPat("b?????????????????010?????0000011")
  def LBU       = BitPat("b?????????????????100?????0000011")
  def LHU       = BitPat("b?????????????????101?????0000011")
  def SB        = BitPat("b?????????????????000?????0100011")
  def SH        = BitPat("b?????????????????001?????0100011")
  def SW        = BitPat("b?????????????????010?????0100011")
  def ADDI      = BitPat("b?????????????????000?????0010011")
  def SLLI      = BitPat("b000000???????????001?????0010011")
  def SLTI      = BitPat("b?????????????????010?????0010011")
  def SLTIU     = BitPat("b?????????????????011?????0010011")
  def XORI      = BitPat("b?????????????????100?????0010011")
  def SRLI      = BitPat("b000000???????????101?????0010011")
  def SRAI      = BitPat("b010000???????????101?????0010011")
  def ORI       = BitPat("b?????????????????110?????0010011")
  def ANDI      = BitPat("b?????????????????111?????0010011")
  def ADD       = BitPat("b0000000??????????000?????0110011")
  def SUB       = BitPat("b0100000??????????000?????0110011")
  def SLL       = BitPat("b0000000??????????001?????0110011")
  def SLT       = BitPat("b0000000??????????010?????0110011")
  def SLTU      = BitPat("b0000000??????????011?????0110011")
  def XOR       = BitPat("b0000000??????????100?????0110011")
  def SRL       = BitPat("b0000000??????????101?????0110011")
  def SRA       = BitPat("b0100000??????????101?????0110011")
  def OR        = BitPat("b0000000??????????110?????0110011")
  def AND       = BitPat("b0000000??????????111?????0110011")

  def FENCETSO  = BitPat("b10000011001100000000000000001111")
  def PAUSE     = BitPat("b00000001000000000000000000001111")
  def FENCE     = BitPat("b?????????????????000?????0001111")
  def ECALL     = BitPat("b00000000000000000000000001110011")
  def EBREAK    = BitPat("b00000000000100000000000001110011")

  // ******************************
  //             RV32F
  // ******************************
  def FADD      = BitPat("b0000000??????????????????1010011")
  def FMVWX     = BitPat("b111100000000?????000?????1010011")

  // ******************************
  //            ZICSR
  // ******************************
  def CSRRW0    = BitPat("b?????????????????001000001110011")
  def CSRRW     = BitPat("b?????????????????001?????1110011")
  def CSRRS0    = BitPat("b????????????00000010?????1110011")
  def CSRRS     = BitPat("b?????????????????010?????1110011")
  def CSRRC0    = BitPat("b????????????00000011?????1110011")
  def CSRRC     = BitPat("b?????????????????011?????1110011")
  def CSRRWI0   = BitPat("b?????????????????101000001110011")
  def CSRRWI    = BitPat("b?????????????????101?????1110011")
  def CSRRSI0   = BitPat("b????????????00000110?????1110011")
  def CSRRSI    = BitPat("b?????????????????110?????1110011")
  def CSRRCI0   = BitPat("b????????????00000111?????1110011")
  def CSRRCI    = BitPat("b?????????????????111?????1110011")
}
