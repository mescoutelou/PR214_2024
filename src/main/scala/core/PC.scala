package emmk.core
import chisel3._
import chisel3.util._
import emmk.common.gen._


class PC extends Module {
    val io = IO(new Bundle{
        val i_donnee = Input(UInt(32.W))
        val i_enable_mux = Input(UInt(1.W))
        val i_enable_PC = Input(UInt(1.W))
        val o_PC_out = Output(UInt(32.W))

    })  

    val PC_in = RegInit(0.U(32.W))    // Signal entre Mux et PC
    val count = RegInit(0.U(32.W))    // Signal entre PC et +4
    val add_out = RegInit(0.U(32.W))  // Signal entre +4 et Mux

    //Partie Multiplexeur
    when (io.i_enable_mux === 0.U){
        PC_in := io.i_donnee
    }
    .elsewhen(io.i_enable_mux === 1.U){
        PC_in := add_out + 1.U
    }
    .otherwise{
        PC_in := DontCare
    }


    //Partie PC
    when (io.i_enable_PC === 0.U){
        count := PC_in
    }
    .elsewhen(io.i_enable_PC === 1.U){
        count := count + 1.U
    }
    .otherwise{
        count := DontCare
    }

    //Partie +4
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