package prj.example

import chisel3._
import chisel3.util._
import _root_.circt.stage.{ChiselStage}


class ExampleAdd (nBit: Int) extends Module {
  val io = IO(new Bundle {
    val i_s1 = Input(UInt(nBit.W))    
    val i_s2 = Input(UInt(32.W))  
    val o_res = Output(UInt(nBit.W))  
  })  

  io.o_res := io.i_s1 + io.i_s2
}

class Example (nBit: Int) extends Module {
  val io = IO(new Bundle {
    val i_s1 = Input(UInt(nBit.W))    
    val i_s2 = Input(UInt(32.W))  

    val o_res = Output(UInt(nBit.W))  
  })  

  val m_add = Module(new ExampleAdd(nBit))
  val r_reg = Reg(UInt(nBit.W))

  m_add.io.i_s1 := io.i_s1
  m_add.io.i_s2 := io.i_s2  
  r_reg := m_add.io.o_res

  io.o_res := r_reg
}
object Example extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Example(4),
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