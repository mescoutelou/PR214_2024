/*
 * File: table-int.scala                                                       *
 * Created Date: 2023-02-25 10:19:59 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-15 11:14:12 am                                       *
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


// ************************************************************
//
//     DECODE TABLES TO EXTRACT GLOBAL AND EX INFORMATION
//
// ************************************************************
trait TABLEINT
{  
    //                        is Valid ?                           Int Unit ?                          S1 Sign            S1 Type ?                    Imm1 Type ?
    //                           |                                    |                                  |   S2 Sign        |       S2 Type ?              |     Imm2 Type ?
    //                           | is Serial ?      Gen Exc ?         |             Int Uop ?            |     |   S3 Sign  |         |       S3 Type ?    |         |
    //                           |     |     WB ?      |  Hang ?      |                |                 |     |     |      |         |         |          |         |
    //                           |     |       |       |     |        |                |                 |     |     |      |         |         |          |         |
  val default: List[UInt] =
               List[UInt](      0.B,  0.B,    0.B,    1.B,  0.B,  INTUNIT.X,        INTUOP.X,           0.B,  0.B,  0.B,  OP.X,     OP.X,     OP.X,     IMM.X,    IMM.X)
  val table: Array[(BitPat, List[UInt])]
}

object TABLEINT32I extends TABLEINT {
  val table : Array[(BitPat, List[UInt])] =
              Array[(BitPat, List[UInt])](

    //                        is Valid ?                           Int Unit ?                          S1 Sign            S1 Type ?                    Imm1 Type ?
    //                           |                                    |                                  |   S2 Sign        |       S2 Type ?              |     Imm2 Type ?
    //                           | is Serial ?      Gen Exc ?         |             Int Uop ?            |     |   S3 Sign  |         |       S3 Type ?    |         |
    //                           |     |     WB ?      |  Hang ?      |                |                 |     |     |      |         |         |          |         |
    //                           |     |       |       |     |        |                |                 |     |     |      |         |         |          |         |
    BASE.LUI          -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.ADD,         1.B,  0.B,  0.B,  OP.IMM1,  OP.IMM2,  OP.X,     IMM.isU,  IMM.is0),
    BASE.AUIPC        -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.ADD,         1.B,  0.B,  0.B,  OP.IMM1,  OP.PC,    OP.X,     IMM.isU,  IMM.X),
    BASE.JAL          -> List(  1.B,  0.B,    1.B,    0.B,  0.B,  INTUNIT.BRU,      INTUOP.JAL,         0.B,  1.B,  0.B,  OP.PC,    OP.IMM1,  OP.X,     IMM.isJ,  IMM.X),
    BASE.JALR         -> List(  1.B,  0.B,    1.B,    0.B,  0.B,  INTUNIT.BRU,      INTUOP.JALR,        0.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.X,     IMM.isI,  IMM.X),
    BASE.BEQ          -> List(  1.B,  0.B,    0.B,    0.B,  0.B,  INTUNIT.BRU,      INTUOP.BEQ,         1.B,  1.B,  1.B,  OP.XREG,  OP.XREG,  OP.IMM1,  IMM.isB,  IMM.X),
    BASE.BNE          -> List(  1.B,  0.B,    0.B,    0.B,  0.B,  INTUNIT.BRU,      INTUOP.BNE,         1.B,  1.B,  1.B,  OP.XREG,  OP.XREG,  OP.IMM1,  IMM.isB,  IMM.X),
    BASE.BLT          -> List(  1.B,  0.B,    0.B,    0.B,  0.B,  INTUNIT.BRU,      INTUOP.BLT,         1.B,  1.B,  1.B,  OP.XREG,  OP.XREG,  OP.IMM1,  IMM.isB,  IMM.X),
    BASE.BGE          -> List(  1.B,  0.B,    0.B,    0.B,  0.B,  INTUNIT.BRU,      INTUOP.BGE,         1.B,  1.B,  1.B,  OP.XREG,  OP.XREG,  OP.IMM1,  IMM.isB,  IMM.X),
    BASE.BLTU         -> List(  1.B,  0.B,    0.B,    0.B,  0.B,  INTUNIT.BRU,      INTUOP.BLT,         0.B,  0.B,  1.B,  OP.XREG,  OP.XREG,  OP.IMM1,  IMM.isB,  IMM.X),
    BASE.BGEU         -> List(  1.B,  0.B,    0.B,    0.B,  0.B,  INTUNIT.BRU,      INTUOP.BGE,         0.B,  0.B,  1.B,  OP.XREG,  OP.XREG,  OP.IMM1,  IMM.isB,  IMM.X),
    BASE.LB           -> List(  1.B,  0.B,    1.B,    1.B,  1.B,  INTUNIT.ALU,      INTUOP.ADD,         0.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.X,     IMM.isI,  IMM.X),
    BASE.LH           -> List(  1.B,  0.B,    1.B,    1.B,  1.B,  INTUNIT.ALU,      INTUOP.ADD,         0.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.X,     IMM.isI,  IMM.X),
    BASE.LW           -> List(  1.B,  0.B,    1.B,    1.B,  1.B,  INTUNIT.ALU,      INTUOP.ADD,         0.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.X,     IMM.isI,  IMM.X),
    BASE.LBU          -> List(  1.B,  0.B,    1.B,    1.B,  1.B,  INTUNIT.ALU,      INTUOP.ADD,         0.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.X,     IMM.isI,  IMM.X),
    BASE.LHU          -> List(  1.B,  0.B,    1.B,    1.B,  1.B,  INTUNIT.ALU,      INTUOP.ADD,         0.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.X,     IMM.isI,  IMM.X),
    BASE.SB           -> List(  1.B,  0.B,    0.B,    1.B,  1.B,  INTUNIT.ALU,      INTUOP.ADD,         0.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.XREG,  IMM.isS,  IMM.X),
    BASE.SH           -> List(  1.B,  0.B,    0.B,    1.B,  1.B,  INTUNIT.ALU,      INTUOP.ADD,         0.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.XREG,  IMM.isS,  IMM.X),
    BASE.SW           -> List(  1.B,  0.B,    0.B,    1.B,  1.B,  INTUNIT.ALU,      INTUOP.ADD,         0.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.XREG,  IMM.isS,  IMM.X),
    BASE.ADDI         -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.ADD,         1.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.X,     IMM.isI,  IMM.X),
    BASE.SLTI         -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.SLT,         1.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.X,     IMM.isI,  IMM.X),
    BASE.SLTIU        -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.SLT,         0.B,  0.B,  0.B,  OP.XREG,  OP.IMM1,  OP.X,     IMM.isI,  IMM.X),
    BASE.XORI         -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.XOR,         1.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.X,     IMM.isI,  IMM.X),
    BASE.ORI          -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.OR,          1.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.X,     IMM.isI,  IMM.X),
    BASE.ANDI         -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.AND,         1.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.X,     IMM.isI,  IMM.X),
    BASE.SLLI         -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.SHL,         1.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.X,     IMM.isI,  IMM.X),
    BASE.SRLI         -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.SHR,         0.B,  0.B,  0.B,  OP.XREG,  OP.IMM1,  OP.X,     IMM.isI,  IMM.X),
    BASE.SRAI         -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.SHR,         1.B,  1.B,  0.B,  OP.XREG,  OP.IMM1,  OP.X,     IMM.isI,  IMM.X),
    BASE.ADD          -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.ADD,         1.B,  1.B,  0.B,  OP.XREG,  OP.XREG,  OP.X,     IMM.X,    IMM.X),
    BASE.SUB          -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.SUB,         1.B,  1.B,  0.B,  OP.XREG,  OP.XREG,  OP.X,     IMM.X,    IMM.X),
    BASE.SLL          -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.SHL,         1.B,  1.B,  0.B,  OP.XREG,  OP.XREG,  OP.X,     IMM.X,    IMM.X),
    BASE.SLT          -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.SLT,         1.B,  1.B,  0.B,  OP.XREG,  OP.XREG,  OP.X,     IMM.X,    IMM.X),
    BASE.SLTU         -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.SLT,         0.B,  0.B,  0.B,  OP.XREG,  OP.XREG,  OP.X,     IMM.X,    IMM.X),
    BASE.XOR          -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.XOR,         1.B,  1.B,  0.B,  OP.XREG,  OP.XREG,  OP.X,     IMM.X,    IMM.X),
    BASE.SRL          -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.SHR,         0.B,  0.B,  0.B,  OP.XREG,  OP.XREG,  OP.X,     IMM.X,    IMM.X),
    BASE.SRA          -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.SHR,         1.B,  1.B,  0.B,  OP.XREG,  OP.XREG,  OP.X,     IMM.X,    IMM.X),
    BASE.OR           -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.OR,          1.B,  1.B,  0.B,  OP.XREG,  OP.XREG,  OP.X,     IMM.X,    IMM.X),
    BASE.AND          -> List(  1.B,  0.B,    1.B,    0.B,  1.B,  INTUNIT.ALU,      INTUOP.AND,         1.B,  1.B,  0.B,  OP.XREG,  OP.XREG,  OP.X,     IMM.X,    IMM.X),

    BASE.FENCETSO     -> List(  1.B,  1.B,    0.B,    0.B,  0.B,  INTUNIT.BRU,      INTUOP.FENCE,       0.B,  0.B,  0.B,  OP.X,     OP.X,     OP.X,     IMM.X,    IMM.X),
    BASE.PAUSE        -> List(  1.B,  1.B,    0.B,    0.B,  0.B,  INTUNIT.BRU,      INTUOP.FENCE,       0.B,  0.B,  0.B,  OP.X,     OP.X,     OP.X,     IMM.X,    IMM.X),
    BASE.FENCE        -> List(  1.B,  1.B,    0.B,    0.B,  0.B,  INTUNIT.BRU,      INTUOP.FENCE,       0.B,  0.B,  0.B,  OP.X,     OP.X,     OP.X,     IMM.X,    IMM.X))
}

object TABLEINT32F extends TABLEINT {
  val table : Array[(BitPat, List[UInt])] =
              Array[(BitPat, List[UInt])](

    //                        is Valid ?                           Int Unit ?                          S1 Sign            S1 Type ?                    Imm1 Type ?
    //                           |                                    |                                  |   S2 Sign        |       S2 Type ?              |     Imm2 Type ?
    //                           | is Serial ?      Gen Exc ?         |             Int Uop ?            |     |   S3 Sign  |         |       S3 Type ?    |         |
    //                           |     |     WB ?      |  Hang ?      |                |                 |     |     |      |         |         |          |         |
    //                           |     |       |       |     |        |                |                 |     |     |      |         |         |          |         |
    BASE.FLW          -> List(  1.B,  0.B,    0.B,    1.B,  0.B,  INTUNIT.X,        INTUOP.X,           0.B,  1.B,  0.B,  OP.XREG,  OP.X,     OP.IMM1,  IMM.isI,  IMM.X),
    BASE.FSW          -> List(  1.B,  0.B,    0.B,    1.B,  0.B,  INTUNIT.X,        INTUOP.X,           0.B,  1.B,  0.B,  OP.XREG,  OP.X,     OP.IMM1,  IMM.isS,  IMM.X),
    BASE.FADDS        -> List(  1.B,  0.B,    0.B,    0.B,  0.B,  INTUNIT.X,        INTUOP.X,           0.B,  0.B,  0.B,  OP.X,     OP.X,     OP.X,     IMM.X,    IMM.X),
    BASE.FSUBS        -> List(  1.B,  0.B,    0.B,    0.B,  0.B,  INTUNIT.X,        INTUOP.X,           0.B,  0.B,  0.B,  OP.X,     OP.X,     OP.X,     IMM.X,    IMM.X),
    BASE.FMVXW        -> List(  1.B,  0.B,    1.B,    0.B,  0.B,  INTUNIT.X,        INTUOP.X,           0.B,  0.B,  0.B,  OP.X,     OP.X,     OP.X,     IMM.X,    IMM.X),
    BASE.FMVWX        -> List(  1.B,  0.B,    0.B,    0.B,  0.B,  INTUNIT.X,        INTUOP.X,           0.B,  0.B,  0.B,  OP.XREG,  OP.X,     OP.X,     IMM.X,    IMM.X))
}


object TABLEINTCSR extends TABLEINT {
  val table : Array[(BitPat, List[UInt])] =
              Array[(BitPat, List[UInt])](

    //                        is Valid ?                           Int Unit ?                          S1 Sign            S1 Type ?                    Imm1 Type ?
    //                           |                                    |                                  |   S2 Sign        |       S2 Type ?              |     Imm2 Type ?
    //                           | is Serial ?      Gen Exc ?         |             Int Uop ?            |     |   S3 Sign  |         |       S3 Type ?    |         |
    //                           |     |     WB ?      |  Hang ?      |                |                 |     |     |      |         |         |          |         |
    //                           |     |       |       |     |        |                |                 |     |     |      |         |         |          |         |
    BASE.CSRRW0       -> List(  1.B,  1.B,    0.B,    1.B,  0.B,  INTUNIT.CSR,      CSRUOP.X,           0.B,  0.B,  0.B,  OP.XREG,  OP.X,     OP.IMM2,  IMM.X,    IMM.isI),
    BASE.CSRRW        -> List(  1.B,  1.B,    1.B,    1.B,  0.B,  INTUNIT.CSR,      CSRUOP.RW,          0.B,  0.B,  0.B,  OP.XREG,  OP.X,     OP.IMM2,  IMM.X,    IMM.isI),
    BASE.CSRRS0       -> List(  1.B,  1.B,    1.B,    1.B,  0.B,  INTUNIT.CSR,      CSRUOP.RS,          0.B,  0.B,  0.B,  OP.XREG,  OP.X,     OP.IMM2,  IMM.X,    IMM.isI),
    BASE.CSRRS        -> List(  1.B,  1.B,    1.B,    1.B,  0.B,  INTUNIT.CSR,      CSRUOP.RX,          0.B,  0.B,  0.B,  OP.XREG,  OP.X,     OP.IMM2,  IMM.X,    IMM.isI),
    BASE.CSRRC0       -> List(  1.B,  1.B,    1.B,    1.B,  0.B,  INTUNIT.CSR,      CSRUOP.RC,          0.B,  0.B,  0.B,  OP.XREG,  OP.X,     OP.IMM2,  IMM.X,    IMM.isI),
    BASE.CSRRC        -> List(  1.B,  1.B,    1.B,    1.B,  0.B,  INTUNIT.CSR,      CSRUOP.RX,          0.B,  0.B,  0.B,  OP.XREG,  OP.X,     OP.IMM2,  IMM.X,    IMM.isI),
    BASE.CSRRWI0      -> List(  1.B,  1.B,    0.B,    1.B,  0.B,  INTUNIT.CSR,      CSRUOP.X,           0.B,  0.B,  0.B,  OP.IMM1,  OP.X,     OP.IMM2,  IMM.isC,  IMM.isI),
    BASE.CSRRWI       -> List(  1.B,  1.B,    1.B,    1.B,  0.B,  INTUNIT.CSR,      CSRUOP.RW,          0.B,  0.B,  0.B,  OP.IMM1,  OP.X,     OP.IMM2,  IMM.isC,  IMM.isI),
    BASE.CSRRSI0      -> List(  1.B,  1.B,    1.B,    1.B,  0.B,  INTUNIT.CSR,      CSRUOP.RX,          0.B,  0.B,  0.B,  OP.IMM1,  OP.X,     OP.IMM2,  IMM.isC,  IMM.isI),
    BASE.CSRRSI       -> List(  1.B,  1.B,    1.B,    1.B,  0.B,  INTUNIT.CSR,      CSRUOP.RS,          0.B,  0.B,  0.B,  OP.IMM1,  OP.X,     OP.IMM2,  IMM.isC,  IMM.isI),
    BASE.CSRRCI0      -> List(  1.B,  1.B,    1.B,    1.B,  0.B,  INTUNIT.CSR,      CSRUOP.RX,          0.B,  0.B,  0.B,  OP.IMM1,  OP.X,     OP.IMM2,  IMM.isC,  IMM.isI),
    BASE.CSRRCI       -> List(  1.B,  1.B,    1.B,    1.B,  0.B,  INTUNIT.CSR,      CSRUOP.RC,          0.B,  0.B,  0.B,  OP.IMM1,  OP.X,     OP.IMM2,  IMM.isC,  IMM.isI))
} 