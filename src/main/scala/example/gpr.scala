package prj.example

import chisel3._
import chisel3.util._
import _root_.circt.stage.{ChiselStage}

class GPR extends Module {
  // Définit les entrées/sorties du module
  val io = IO(new Bundle {

    //Ecriture
    val i_data = Input(UInt(32.W))      //Donnée en entrée des registres
    val i_write = Input(Bool())         //Activation de l'écriture sur le registre  
    val i_sel_reg = Input(UInt(5.W))    //Numero du registre d'écriture

    //Lecture
    val i_read_reg1 = Input(UInt(5.W))  //Numero du registre entre 0 et 31 = 5 bits
    val i_read_reg2 = Input(UInt(5.W))

    val o_data_reg1 = Output(UInt(32.W))
    val o_data_reg2 = Output(UInt(32.W))

  })
  
  
  val registerFile = Reg(Vec(32,UInt(32.W)))  //File de 32 registres de 32 bits
  
  val i_sel_reg = Reg(UInt(5.W))
  i_sel_reg := io.i_sel_reg 

  when(io.i_write) {        //Ecriture
    registerFile(i_sel_reg) := io.i_data
  }

  io.o_data_reg1 := registerFile(io.i_read_reg1)
  io.o_data_reg2 := registerFile(io.i_read_reg2)

  registerFile(0) := 0.U                    //registre x0

  dontTouch(registerFile)
}


object GPR extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new GPR,
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