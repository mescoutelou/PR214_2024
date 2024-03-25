package prj.example

import chisel3._
import chisel3.util._
import _root_.circt.stage.{ChiselStage}

class top_end extends Module {
  val io = IO(new Bundle {
    val i_mem = Input(UInt(32.W))
    val o_mem = Output(UInt(32.W))
  })

val top = Module(new top)
val fetch = Module(new fetch)



fetch.io.i_jumpAdr := DontCare
fetch.io.i_jumpEnable := DontCare
top.io.i_instr := io.i_mem
io.o_mem := fetch.io.o_instrAdr 





}

object top_end extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new top_end,
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