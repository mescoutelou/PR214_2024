/*
 * File: bus.scala                                                             *
 * Created Date: 2024-04-08 09:31:37 am                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-10 10:43:30 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.betizu

import chisel3._
import chisel3.util._

import emmk.common.gen._


// ******************************
//             COMMON            
// ******************************
class BranchBus(p: BetizuParams) extends Bundle {
  val valid = Bool()
  val addr = UInt(p.nAddrBit.W)
}

// ******************************
//             FRONT            
// ******************************
class FetchBus(p: BetizuParams) extends Bundle {
  val en = Bool()
  val pc = UInt(p.nAddrBit.W)
  val instr = UInt(p.nInstrBit.W)
}

// ******************************
//              BACK            
// ******************************
// ------------------------------
//              GPR            
// ------------------------------
class GprReadIO(p: BetizuParams) extends Bundle {
  val valid = Input(Bool())
  val addr = Input(UInt(5.W))
  val ready = Output(Bool())
  val data = Output(UInt(p.nDataBit.W))
}

class GprWriteIO(p: BetizuParams) extends Bundle {
  val valid = Input(Bool())
  val addr = Input(UInt(5.W))
  val data = Input(UInt(p.nDataBit.W))
}

class BypassBus(p: BetizuParams) extends Bundle {
  val valid = Bool()
  val ready = Bool()
  val addr = UInt(5.W)
  val data = UInt(p.nDataBit.W)
}

// ------------------------------
//          INFORMATION            
// ------------------------------
class InfoBus(p: BetizuParams) extends Bundle {
  val pc = UInt(p.nAddrBit.W)
  val instr = UInt(p.nInstrBit.W)
  val ser = Bool()
  val hang = Bool()
}

// ------------------------------
//            CONTROL
// ------------------------------
class IntCtrlBus extends Bundle {
  val unit = UInt(INTUNIT.NBIT.W)
  val uop = UInt(INTUOP.NBIT.W)
  val ssign = Vec(3, Bool())
}

class LsuCtrlBus extends Bundle {
  val use = Bool()
  val uop = UInt(LSUUOP.NBIT.W)
  val size = UInt(LSUSIZE.NBIT.W)
  val sign = UInt(LSUSIGN.NBIT.W)

  def ld: Bool = use & (uop === LSUUOP.R)
  def st: Bool = use & (uop === LSUUOP.W)
}

class GprCtrlBus() extends Bundle {
  val en = Bool()
  val addr = UInt(5.W)
  val byp = Bool()
}

class ExtCtrlBus extends Bundle {
  val pack = Bool()
  val ext = UInt(EXT.NBIT.W)
  val code = UInt(8.W)
  val op = Vec(3, UInt(3.W))
  val rs = Vec(3, UInt(5.W))
  val rd = UInt(5.W)
}

class ExCtrlBus(p: BetizuParams) extends Bundle {
  val info = new InfoBus(p)

  val int = new IntCtrlBus()
  val lsu = new LsuCtrlBus()
  val gpr = new GprCtrlBus()

  val ext = new ExtCtrlBus()
}

class ExBufferBus(p: BetizuParams) extends Bundle {
  val info = new InfoBus(p)

  val multi = UInt(MULTI.NBIT.W)
  val lsu = new LsuCtrlBus()
  val gpr = new GprCtrlBus()
}

// ------------------------------
//              DATA
// ------------------------------
class DataSlctBus extends Bundle {
  val rs1 = UInt(5.W)
  val rs2 = UInt(5.W)
  val s1type = UInt(OP.NBIT.W)
  val s2type = UInt(OP.NBIT.W)
  val s3type = UInt(OP.NBIT.W)
  val imm1type = UInt(IMM.NBIT.W)
  val imm2type = UInt(IMM.NBIT.W)
}

class DataBus(p: BetizuParams) extends Bundle {
  val s1 = UInt(p.nDataBit.W)
  val s2 = UInt(p.nDataBit.W)
  val s3 = UInt(p.nDataBit.W)
}

// ******************************
//          INTEGER UNIT
// ******************************
class IntUnitReqCtrlBus(p: BetizuParams) extends Bundle {
  val uop = UInt(INTUOP.NBIT.W)
  val pc = UInt(p.nAddrBit.W)
  val ssign = Vec(3, Bool())
}

class IntUnitReqDataBus(p: BetizuParams) extends Bundle {
  val s1 = UInt(p.nDataBit.W)
  val s2 = UInt(p.nDataBit.W)
  val s3 = UInt(p.nDataBit.W)
}

class IntUnitIO(p: BetizuParams) extends Bundle {
  val req = Flipped(new GenRVIO(p, new IntUnitReqCtrlBus(p), new IntUnitReqDataBus(p)))
  val ack = new GenRVIO(p, UInt(0.W), UInt(p.nDataBit.W))
}

// ******************************
//              CSR
// ******************************
class CsrIO(p: BetizuParams) extends Bundle {
  val valid = Input(Bool())
  val uop = Input(UInt(CSRUOP.NBIT.W))
  val addr = Input(UInt(12.W))
  val wdata = Input(UInt(p.nDataBit.W))
  val ready = Output(Bool())
  val rdata = Output(UInt(p.nDataBit.W))

  def read(): Bool = {
    return (uop === CSRUOP.RX) | (uop === CSRUOP.RW) | (uop === CSRUOP.RS) | (uop === CSRUOP.RC)
  }
  def write(): Bool = {
    return (uop === CSRUOP.W) | (uop === CSRUOP.RW)
  }
  def set(): Bool = {
    return (uop === CSRUOP.S) | (uop === CSRUOP.RS)
  }
  def clear(): Bool = {
    return (uop === CSRUOP.C) | (uop === CSRUOP.RC)
  }
  def modify: Bool = {
    return write() | set() | clear()
  }
}