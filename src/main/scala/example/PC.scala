package prj.example
import chisel3._
import chisel3.util._
import prj.common.gen._


class PC extends Module {
    val io = IO(new Bundle{
        val i_count_out = Input(UInt(32.W))
        val i_donnee = Input(UInt(32.W))
        val i_enable_mux = Input(Bool())
        val i_enable_PC = Input(UInt(1.W))
        val o_PC_out = Output(UInt(32.W))

    })

    val count = 0.U(32.W)
    val PC_in = 0.U(32.W)
    
    PC_in := Mux(io.i_enable_mux, io.i_donnee, io.i_count_out) //Mux avant le PC

    when (io.i_enable_PC === 0.U){
        count := PC_in
    }
    .elsewhen(io.i_enable_PC === 1.U){
        count := count + 1.U
    }
    .otherwise{
        count := 0.U
    }
    //count := Mux(io.i_enable_PC, PC_in, count + 1.U) //PC

    io.o_PC_out := count 
}





object PC extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new PC,
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