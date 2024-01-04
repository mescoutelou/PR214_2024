/*
 * File: bundle.scala                                                          *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-04 11:36:19 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2023 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.example

import chisel3._
import chisel3.util._
import _root_.circt.stage.{ChiselStage}

// Définit un groupe de signaux allant tous dans la même direction
class BundleBus (nBit: Int) extends Bundle {
  val valid = Bool()
  val data = UInt(nBit.W)
}

// Définit un groupe d'entrées/sorties
class BundleIO (nBit: Int) extends Bundle {
  val ready = Input(Bool())
  val valid = Output(Bool())
  val data = Output(UInt(nBit.W))
}

// Module ExampleBundle
// Connecte des groupes de signaux entre eux et avec un registre interne
class ExampleBundle(nBit: Int) extends Module {
  // Définit les entrées/sorties du module
  val io = IO(new Bundle {
    // Flipped -> inverse la direction des signaux 
    val b_in = Flipped(new BundleIO(nBit)) 
    val b_out = new BundleIO(nBit)
    val o_reg = Output(new BundleBus(nBit))  
  })  

  // Définit un signal utilisé pour la création d'un registre du même type mais avec des valeurs particulières
  val init_reg = Wire(new BundleBus(nBit))
  // valid est initialisé à 0
  init_reg.valid := false.B
  // data n'a pas de valeur particulière à l'initialisation
  init_reg.data := DontCare

  // Crée un registre du même type qu'init_reg, et donc les valeurs au reset sont identiques à init_reg
  val r_reg = RegInit(init_reg)

  // Connecte tous les signaux de b_out à b_in et inversement
  io.b_out <> io.b_in

  // Connecte les signaux du registre
  r_reg.valid := io.b_in.valid & io.b_out.ready
  r_reg.data := io.b_in.data

  // Connecte les sorties
  io.o_reg := r_reg
}

// Objet pour générer le SystemVerilog du module ExampleBundle
// Passe la valeur 4 en paramètre
object ExampleBundle extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new ExampleBundle(4),
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