package prj.example

import chisel3._
import chisel3.util._
import _root_.circt.stage.{ChiselStage}

class top extends Module {
  val io = IO(new Bundle {
    val i_instr = Input(UInt(32.W))

    //Valeur registre de destination
    val res = Output(UInt(32.W))
  })

  val GPR = Module(new GPR)
  val ALU = Module(new ALU)
  val Decodeur = Module(new Decodeur)
 
  ALU.io.i_rs1 := GPR.o_data_reg1
  ALU.io.operande := Mux(Decodeur.io.o_sel_operande,Decodeur.io.o_imm,GPR.io.o_data_reg2)
  ALU.io.funct_sel := Decodeur.io.funct_sel
  ALU.io.o_rd := GPR.io.i_data
  //mettre le registre de destination en sortie du décodeur
}



object top extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new top,
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