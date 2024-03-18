package prj.example
import chisel3._
import chisel3.util._
import prj.common.gen._


class PC extends Module {
    val io = IO(new Bundle{
        val i_donnee = Input(UInt(32.W))
        val i_enable_mux = Input(UInt(1.W))
        val i_enable_PC = Input(UInt(1.W))
        val o_PC_out = Output(UInt(32.W))

    })  

    val count = RegInit(0.U(32.W))
    val PC_in = RegInit(0.U(32.W))
    val add_out = RegInit(0.U(32.W))
    when (io.i_enable_mux === 0.U){
        PC_in := io.i_donnee
    }
    .elsewhen(io.i_enable_mux === 1.U){
        PC_in := add_out + 1.U
    }
    .otherwise{
        PC_in := DontCare
    }


    when (io.i_enable_PC === 0.U){
        count := PC_in
    }
    .elsewhen(io.i_enable_PC === 1.U){
        count := count + 1.U
    }
    .otherwise{
        count := DontCare
    }

    add_out := count + 4.U

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