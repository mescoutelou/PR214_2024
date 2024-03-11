package prj.example
import chisel3._
import chisel3.util._
import prj.common.gen._


class PC extend module {
    val io = IO(new Bundle{
        val i_PC_in = Input(UInt(32.W))
        val i_enable = Input(UInt(1.W))
        val o_PC_out = Output(UInt(32.W))

    })
}

val count = WireDefault(0.U(32.W))

count = mux(io.i_enable, io.i_PC_in, count + 1)

io.o_PC_out := count 



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