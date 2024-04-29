package prj.example
import chisel3._
import chisel3.util._
import _root_.circt.stage.{ChiselStage}



class Memoire extends Module {
  // Définit les entrées/sorties du module
    val io = IO(new Bundle {
    val i_wEnable = Input(Bool())           //Active l'écriture
    val i_rEnable = Input(Bool())           //Acrive la lecture
    val i_data = Input(UInt(32.W))          //Donnée à écrire
    val i_Adr = Input(UInt(6.W))           //Adresse de la donnée
    val o_data = Output(UInt(32.W))         //Donnée à lire
  })

    //Tableau mémoire
    val memoire = SyncReadMem(1024, UInt(32.W))     // Memoire de 1024
    //Lecture
    when(io.i_rEnable){
        io.o_data := memoire(io.i_Adr)
    }.otherwise{io.o_data := DontCare}

    //Ecriture
    when(io.i_wEnable){
        memoire(io.i_Adr) := io.i_data
    }
}



object Memoire extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Memoire,
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


