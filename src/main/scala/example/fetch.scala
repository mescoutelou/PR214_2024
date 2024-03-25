package prj.example
import chisel3._
import chisel3.util._
import prj.common.gen._


class fetch extends Module {
    val io = IO(new Bundle{
        // Adresse du saut
        val i_jumpAdr = Input(UInt(32.W))

        // Activation du saut
        val i_jumpEnable = Input(Bool())

        // Adresse de sortie du PC
        val o_instrAdr = Output(UInt(32.W))
    })  


    // ADD (+4)
    val instrAdr = io.o_instrAdr
    val addOut = instrAdr + 4.U


    // PC

    val PC_in = RegInit(0.U(32.W))

    // Si jumpEnable = true.b alors saut à jumpAdr
    // Sinon currentAdr = currentAdr + 4
    val currentAdr = Mux(io.i_jumpEnable, io.i_jumpAdr, addOut)
    
    PC_in := currentAdr
    instrAdr := PC_in
}




object fetch extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new fetch,
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