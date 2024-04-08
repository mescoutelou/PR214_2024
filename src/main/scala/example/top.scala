package prj.example

import chisel3._
import chisel3.util._
import _root_.circt.stage.{ChiselStage}

class top extends Module {
  val io = IO(new Bundle {
    val i_instr = Input(UInt(32.W))

    val bypassEnable = Input(Bool())
  })

  val GPR = Module(new GPR)
  val ALU = Module(new ALU)
  val Decodeur = Module(new Decodeur)
 
  //ALU.io.i_rs1 := GPR.io.o_data_reg1
  ALU.io.i_rs1 := Mux(io.bypassEnable,ALU.io.o_rd,GPR.io.o_data_reg1)
  ALU.io.i_operande := Mux(Decodeur.io.o_sel_operande,GPR.io.o_data_reg2,Decodeur.io.o_imm)
  ALU.io.funct_sel := Decodeur.io.funct_sel


  GPR.io.i_data := ALU.io.o_rd
  GPR.io.i_write := true.B
  GPR.io.i_sel_reg := Decodeur.io.o_rd
  GPR.io.i_read_reg1 := Decodeur.io.o_rs1
  GPR.io.i_read_reg2 := Decodeur.io.o_rs2
  
  Decodeur.io.i_instruct := io.i_instr
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