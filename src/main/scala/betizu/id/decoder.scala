/*
 * File: decoder.scala                                                         *
 * Created Date: 2023-02-25 10:19:59 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-09 11:41:04 am                                       *
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


class Decoder(p: BetizuParams) extends Module {
  val io = IO(new Bundle {
    val i_instr = Input(UInt(p.nInstrBit.W))

    val o_info = Output(new InfoBus(p))

    val o_int = Output(new IntCtrlBus())
    val o_lsu = Output(new LsuCtrlBus())
    val o_gpr = Output(new GprCtrlBus())

    val o_ext = Output(new ExtCtrlBus())

    val o_data = Output(new DataSlctBus())
  })

  // ******************************
  //         DECODER LOGIC
  // ******************************
  // Integer table
  var t_int = TABLEINT32I.table
  if (p.useFpu)           t_int ++= TABLEINT32F.table

  // LSU table
  var t_lsu = TABLELSU32I.table

  // External table
  var t_ext = TABLEEXT32I.table
  if (p.useFpu)           t_ext ++= TABLEEXT32F.table

  // Decoded signals
  val w_dec_int = ListLookup(io.i_instr, TABLEINT32I.default, t_int)
  val w_dec_lsu = ListLookup(io.i_instr, TABLELSU32I.default, t_lsu)
  val w_dec_ext = ListLookup(io.i_instr, TABLEEXT32I.default, t_ext)

  // ******************************
  //            INFO BUS
  // ******************************
  val w_ser = Wire(Bool())
  val w_byp = Wire(Bool())

  w_ser := false.B
  w_byp := true.B

  // ------------------------------
  //             GLOBAL
  // ------------------------------
  io.o_info.pc := 0.U
  io.o_info.instr := io.i_instr
  io.o_info.ser := w_dec_int(1) | w_ser

  // ******************************
  //            EX BUS
  // ******************************
  io.o_int.unit := w_dec_int(4)
  io.o_int.uop := w_dec_int(5)
  io.o_int.ssign(0) := w_dec_int(6)
  io.o_int.ssign(1) := w_dec_int(7)
  io.o_int.ssign(2) := w_dec_int(8)

  // ******************************
  //            LSU BUS
  // ******************************
  io.o_lsu.use := w_dec_lsu(0)
  io.o_lsu.uop := w_dec_lsu(1)
  io.o_lsu.size := w_dec_lsu(2)
  io.o_lsu.sign := w_dec_lsu(3)

  // ******************************
  //            WB BUS
  // ******************************
  io.o_gpr.en := w_dec_int(2)
  io.o_gpr.addr := io.i_instr(11,7)
  io.o_gpr.byp := w_byp

  // ******************************
  //            EXTERNAL
  // ******************************
  io.o_ext.ext := w_dec_ext(0)
  io.o_ext.code := w_dec_ext(1)
  io.o_ext.op(0) := w_dec_ext(2)
  io.o_ext.op(1) := w_dec_ext(3)
  io.o_ext.op(2) := w_dec_ext(4)
  io.o_ext.rs(0) := io.i_instr(19,15)
  io.o_ext.rs(1) := io.i_instr(24,20)
  io.o_ext.rs(2) := io.i_instr(31,27)
  io.o_ext.rd := io.i_instr(11, 7)

  // ******************************
  //            DATA BUS
  // ******************************
  io.o_data.rs1 := io.i_instr(19,15)
  io.o_data.rs2 := io.i_instr(24,20)
  io.o_data.s1type := w_dec_int(9)
  io.o_data.s2type := w_dec_int(10)
  io.o_data.s3type := w_dec_int(11)
  io.o_data.imm1type := w_dec_int(12)
  io.o_data.imm2type := w_dec_int(13)
}


class SlctSource(p: BetizuParams) extends Module {
  val io = IO(new Bundle {
    val i_src_type = Input(UInt(OP.NBIT.W))
    val i_rs = Input(UInt(p.nDataBit.W))
    val i_imm1 = Input(UInt(p.nDataBit.W))
    val i_imm2 = Input(UInt(p.nDataBit.W))
    val i_pc = Input(UInt(p.nDataBit.W))
    val i_instr = Input(UInt(p.nInstrBit.W))

    val o_val = Output(UInt(p.nDataBit.W))
  })

  io.o_val := 0.U
  switch (io.i_src_type) {
    is (OP.XREG)  {io.o_val := io.i_rs}
    is (OP.IMM1)  {io.o_val := io.i_imm1}
    is (OP.IMM2)  {io.o_val := io.i_imm2}
    is (OP.PC)    {io.o_val := io.i_pc}
    is (OP.INSTR) {io.o_val := io.i_instr}
  }
}

class SlctImm(p: BetizuParams) extends Module {
  val io = IO(new Bundle {
    val i_instr = Input(UInt(p.nInstrBit.W))
    val i_imm_type = Input(UInt(IMM.NBIT.W))
    val o_val = Output(UInt(p.nDataBit.W))
  })

  io.o_val := 0.U
  switch (io.i_imm_type) {
    is (IMM.is0) {io.o_val := 0.U}
    is (IMM.isR) {io.o_val := Cat(Fill(p.nDataBit - 6,  io.i_instr(31)),  io.i_instr(30,25))}
    is (IMM.isI) {io.o_val := Cat(Fill(p.nDataBit - 11, io.i_instr(31)),  io.i_instr(30,20))}
    is (IMM.isS) {io.o_val := Cat(Fill(p.nDataBit - 11, io.i_instr(31)),  io.i_instr(30,25),  io.i_instr(11,7))}
    is (IMM.isB) {io.o_val := Cat(Fill(p.nDataBit - 12, io.i_instr(31)),  io.i_instr(7),      io.i_instr(30,25),  io.i_instr(11,8), 0.U(1.W))}
    is (IMM.isU) {io.o_val := Cat(Fill(p.nDataBit - 31, io.i_instr(31)),  io.i_instr(30,12),  0.U(12.W))}
    is (IMM.isJ) {io.o_val := Cat(Fill(p.nDataBit - 20, io.i_instr(31)),  io.i_instr(19,12),  io.i_instr(20),     io.i_instr(30,21), 0.U(1.W))}
    is (IMM.isC) {io.o_val := Cat(Fill(p.nDataBit - 5,  0.B),             io.i_instr(19,15))}
    is (IMM.isV) {io.o_val := Cat(Fill(p.nDataBit - 5,  io.i_instr(19)),  io.i_instr(19,15))}
    is (IMM.isZ) {io.o_val := Cat(Fill(p.nDataBit - 10, 0.B),             io.i_instr(29,20))}
  }
}

object Decoder extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Decoder(BetizuConfigBase),
    firtoolOpts = Array.concat(
      Array(
        "--disable-all-randomization",
        "--strip-debug-info",
        "--split-verilog"
      ),
      args
    )      
  )
}
