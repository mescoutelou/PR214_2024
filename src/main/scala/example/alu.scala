package prj.example

import chisel3._
import chisel3.util._
import _root_.circt.stage.{ChiselStage}


// Module ALU
class ALU (nBit: Int) extends Module {
  // Définit les entrées/sorties du module
  val io = IO(new Bundle {
    val i_rs1 = Input(UInt(nBit.W))    
    val i_operande = Input(UInt(nBit.W))
    val funct_sel = Input(UInt(5.W))
    val o_rd = Output(UInt(nBit.W))
  })


val rs1 = io.i_rs1
val operande = io.i_operande
val funct = io.funct_sel
val res = WireDefault(0.U(nBit.W))

 switch(funct){
  is(0.U) {res := rs1 + operande}
  is(1.U) {res := rs1 - operande}
  is(2.U) {res := rs1 ^ operande }
  is(3.U) {res := rs1 | operande}
  is(4.U) {res := rs1 & operande}
  is(5.U) {res := rs1 << operande(4,0)}
  is(6.U) {res := rs1 >> operande(4,0)}
  is(7.U) {res := (rs1.asSInt >> operande(4,0)).asUInt}
 }

 io.o_rd := res
}


// Objet pour générer le SystemVerilog du module ALU
// Passe la valeur 32 en paramètre
object ALU extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new ALU(32),
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



