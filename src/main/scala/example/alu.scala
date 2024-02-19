package prj.example

import chisel3._
import chisel3.util._
import _root_.circt.stage.{ChiselStage}


// Module ALU
class ALU extends Module {
  // Définit les entrées/sorties du module
  val io = IO(new Bundle {
    val i_rs1 = Input(UInt(32.W))    
    val i_operande = Input(UInt(32.W))
    val funct_sel = Input(UInt(5.W))
    val o_rd = Output(UInt(32.W))
  })


val rs1 = io.i_rs1
val operande = io.i_operande
val funct = io.funct_sel
val res = WireDefault(0.U(32.W))

 switch(funct){
  is(0.U) {res := rs1 + operande}
  is(1.U) {res := rs1 - operande}
  is(2.U) {res := rs1 ^ operande}
  is(3.U) {res := rs1 | operande}
  is(4.U) {res := rs1 & operande}
  is(5.U) {res := rs1 << operande(4,0)}
  is(6.U) {res := rs1 >> operande(4,0)}
  is(7.U) {res := (rs1.asSInt >> operande(4,0)).asUInt}
 }

 io.o_rd := res
}



object ALU extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new ALU,
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



