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
 
  ALU.io.i_rs1 := GPR.io.o_data_reg1
  ALU.io.i_operande := Mux(Decodeur.io.o_sel_operande,Decodeur.io.o_imm,GPR.io.o_data_reg2)
  ALU.io.funct_sel := Decodeur.io.funct_sel


  GPR.io.i_data := ALU.io.o_rd
  GPR.io.i_write := true.B
  GPR.io.i_sel_reg := Decodeur.io.o_rd
  GPR.io.i_read_reg1 := Decodeur.io.o_rs1
  GPR.io.i_read_reg2 := Decodeur.io.o_rs2
  
  io.i_instr := Decodeur.io.i_instruct
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