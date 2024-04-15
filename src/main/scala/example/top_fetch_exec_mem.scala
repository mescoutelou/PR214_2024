package prj.example
import chisel3._
import chisel3.util._
import _root_.circt.stage.{ChiselStage}


class top_fetch_exec_mem extends Module {
  val io = IO(new Bundle {
  })

    //FETCH
    val fetch = Module(new fetch)

    //EXEC
    val GPR = Module(new GPR)
    val ALU = Module(new ALU)
    val Decodeur = Module(new Decodeur)

    //MEMOIRE
    val Memoire = Module(new Memoire)

    //C0NNECTION MODULES

    fetch.io.i_jumpAdr := DontCare
    fetch.io.i_jumpEnable := DontCare
    Memoire.io.i_rAdr := fetch.io.o_instrAdr

    Memoire.io.i_wEnable := Decodeur.io.o_wEnable
    Memoire.io.i_rEnable := Decodeur.io.o_rEnable
    Memoire.io.i_data := ALU.io.o_rd
    Memoire.io.i_wAdr := Decodeur.io.o_rd
    Decodeur.io.i_instruct := Memoire.io.o_data

    ALU.io.i_operande := Mux(Decodeur.io.o_sel_operande,GPR.io.o_data_reg2,Decodeur.io.o_imm)
    ALU.io.funct_sel := Decodeur.io.funct_sel
    ALU.io.i_rs1 := GPR.io.o_data_reg1
    
    GPR.io.i_data := ALU.io.o_rd
    GPR.io.i_write := Decodeur.io.o_GPRwrite
    GPR.io.i_sel_reg := Decodeur.io.o_rd
    GPR.io.i_read_reg1 := Decodeur.io.o_rs1
    GPR.io.i_read_reg2 := Decodeur.io.o_rs2
    

    Memoire.io.memoire(0) = "b0000000_00010_00001_000_00001_0010011".U
}




object top_fetch_exec_mem extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new top_fetch_exec_mem,
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