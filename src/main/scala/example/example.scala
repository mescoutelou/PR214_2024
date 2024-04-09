/*
 * File: example.scala                                                         *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-04 11:11:15 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2023 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.example

import chisel3._
import chisel3.util._
import _root_.circt.stage.{ChiselStage}

// Module ExampleAdd
class ExampleAdd (nBit: Int) extends Module {
  // Définit les entrées/sorties du module
  val io = IO(new Bundle {
    val i_s1 = Input(UInt(nBit.W))    
    val i_s2 = Input(UInt(32.W))  
    val o_res = Output(UInt(nBit.W))  
  })  

  // Donne à la sortie le résultat de l'addition des entrées
  io.o_res := io.i_s1 + io.i_s2
}

// Module Example
class Example (nBit: Int) extends Module {
  // Définit les entrées/sorties du module
  val io = IO(new Bundle {
    val i_s1 = Input(UInt(nBit.W))    
    val i_s2 = Input(UInt(32.W))  

    val o_res = Output(UInt(nBit.W))  
  })  

  // Crée une instance du module ExampleAdd en utilisant en paramètre la valeur nBit
  val m_add = Module(new ExampleAdd(nBit))
  // Crée un registre de taille nBit, sans valeur initialisée par un reset
  val r_reg = Reg(UInt(nBit.W))

  // Connecte les entrées du module
  m_add.io.i_s1 := io.i_s1
  m_add.io.i_s2 := io.i_s2  
  // Connecte le registre à la sortie du Module
  r_reg := m_add.io.o_res

  // Connecte la sortie au registre
  io.o_res := r_reg
}

// Objet pour générer le SystemVerilog du module ExampleAdd
// Passe la valeur 16 en paramètre
object ExampleAdd extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new ExampleAdd(16),
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

// Objet pour générer le SystemVerilog du module Example
// Passe la valeur 4 en paramètre
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