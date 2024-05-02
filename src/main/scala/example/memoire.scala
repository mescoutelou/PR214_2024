package prj.example
import chisel3._
import chisel3.util._
import prj.common.gen._
import chisel3.util.experimental.loadMemoryFromFileInline
import _root_.circt.stage.{ChiselStage}



class InitMemInline(memoryFile: String = "doc_memoire/mem.txt") extends Module {
  val width: Int = 32
  val io = IO(new Bundle {
    val i_rEnable = Input(Bool())
    val i_wEnable = Input(Bool())
    val i_Adr = Input(UInt(6.W))
    val i_data = Input(UInt(width.W))
    val o_data = Output(UInt(width.W))
  })

  val memoire = SyncReadMem(1024, UInt(width.W))
  // Initialize memory
  if (memoryFile.trim().nonEmpty) {
    loadMemoryFromFileInline(memoire, memoryFile)
  }

  //Lecture
  when(io.i_rEnable){
        io.o_data := memoire.read(io.i_Adr >> 2.U)
    }.otherwise{io.o_data := DontCare}

    //Ecriture
    when(io.i_wEnable){
        memoire.write(io.i_Adr >> 2.U, io.i_data)
    }
    
}



object InitMemInline extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new InitMemInline("doc_memoire/mem.txt"),
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


