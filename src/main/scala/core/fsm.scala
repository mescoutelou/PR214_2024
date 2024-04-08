/*
 * File: fsm.scala                                                             *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-04 11:32:23 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2023 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.core

import chisel3._
import chisel3.util._
import _root_.circt.stage.{ChiselStage}

// Définit les états d'une FSM dans un objet appelé FSM
object FSM extends ChiselEnum {
  val s0WAIT, s1EDGE, s2HIGH = Value
}

// Module ExampleFsm
// Détecte un front montant sur l'entrée
class ExampleFsm extends Module {
  // Importe les états de la FSM
  import prj.core.FSM._

  // Définit les entrées/sorties du module
  val io = IO(new Bundle {
    val i_in = Input(Bool())    
    val o_out = Output(Bool())  
  })  

  // Crée un registre pour l'état de la FSM, initialisé au reset à l'état s0WAIT 
  val r_fsm = RegInit(s0WAIT)

  // Cas par défaut
  r_fsm := s0WAIT

  // Calcul de la fsm
  switch (r_fsm) {
    // Etat s0WAIT: on attend le front montant
    is (s0WAIT) {
      when (io.i_in) {
        r_fsm := s1EDGE
      }.otherwise {
        r_fsm := s0WAIT
      }
    }

    // Etat s1EDGE: le front montant est détecté
    is (s1EDGE) {
      when (io.i_in) {
        r_fsm := s2HIGH
      }.otherwise {
        r_fsm := s0WAIT
      }
    }

    // Etat s2HIGH: on attend que l'entrée repase à zéro
    is (s2HIGH) {
      when (io.i_in) {
        r_fsm := s2HIGH
      }.otherwise {
        r_fsm := s0WAIT
      }
    }

    // Simplification possible
    /*
    is (s1EDGE, s2HIGH) {
      when (io.i_in) {
        r_fsm := s2HIGH
      }.otherwise {
        r_fsm := s0WAIT
      }
    }
    */
  }

  // Connecte la sortie
  io.o_out := (r_fsm === s1EDGE) 
}

// Objet pour générer le SystemVerilog du module ExampleFsm
object ExampleFsm extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new ExampleFsm(),
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