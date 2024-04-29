package prj.example
import chisel3._
import chisel3.util._
import _root_.circt.stage.{ChiselStage}

class top_end extends Module {
  val io = IO(new Bundle {
    val o_mem = Output(UInt(32.W))
  })

val top = Module(new top)
val fetch = Module(new fetch)
val memoire = Module(new InitMemInline("C:/Users/noahm/Documents/Projet RISC-V/PR214_2024/doc_memoire/mem.txt"))


fetch.io.i_jumpAdr := DontCare
fetch.io.i_jumpEnable := DontCare
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