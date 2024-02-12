package prj.example

import chisel3._
import chisel3.util._
import _root_.circt.stage.{ChiselStage}



class GPR extends Module {
  // Définit les entrées/sorties du module
  val io = IO(new Bundle {
    val i_data = Input(UInt(32.W))    
    val i_load = Input(UInt(32.W)) 
    val i_sel_reg = Input(UInt(5.W)) 
    val o_data = Output(UInt(32.W)) 
  })  


}