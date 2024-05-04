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

    //MEMOIRES
    val i_mem = Module(new InitMemInline("doc_memoire/i_mem.txt"))
    val d_mem = Module(new InitMemInline("doc_memoire/d_mem.txt"))

    //CONNECTIONS MODULES

    fetch.io.i_jumpAdr := DontCare
    fetch.io.i_jumpEnable := DontCare
    i_mem.io.i_Adr := fetch.io.o_instrAdr

    i_mem.io.i_wEnable := DontCare
    i_mem.io.i_rEnable := true.B
    i_mem.io.i_data := DontCare

    d_mem.io.i_wEnable := Decodeur.io.o_wEnable
    d_mem.io.i_rEnable := Decodeur.io.o_rEnable
    d_mem.io.i_Adr := ALU.io.o_rd
    d_mem.io.i_data := GPR.io.o_data_reg2
    

    Decodeur.io.i_instruct := i_mem.io.o_data

    ALU.io.i_operande := Mux(Decodeur.io.o_sel_operande,GPR.io.o_data_reg2,Decodeur.io.o_imm)
    ALU.io.funct_sel := Decodeur.io.funct_sel
    ALU.io.i_rs1 := GPR.io.o_data_reg1
    
    GPR.io.i_data := Mux(Decodeur.io.o_rEnable, d_mem.io.o_data,ALU.io.o_rd)
    GPR.io.i_write := Decodeur.io.o_GPRwrite
    GPR.io.i_sel_reg := Decodeur.io.o_rd
    GPR.io.i_read_reg1 := Decodeur.io.o_rs1
    GPR.io.i_read_reg2 := Decodeur.io.o_rs2
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