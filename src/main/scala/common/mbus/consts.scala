/*
 * File: consts.scala                                                          *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 12:14:36 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.common.mbus

import chisel3._
import chisel3.util._


object SIZE {
  def NBIT  = 3

  def B0    = 0
  def B1    = 1
  def B2    = 2
  def B4    = 3
  def B8    = 4
  def B16   = 5

  def toSize (nByte: Int) = {
    if (nByte >= 16) B16
    else if (nByte >= 8) B8
    else if (nByte >= 4) B4
    else if (nByte >= 2) B2
    else if (nByte >= 1) B1
    else B0
  }

  def toByte(size: UInt): UInt = {
    val w_nbyte = Wire(UInt(5.W))

    w_nbyte := 0.U
    switch (size) {
      is (B1.U)   {w_nbyte := 1.U}
      is (B2.U)   {w_nbyte := 2.U}
      is (B4.U)   {w_nbyte := 4.U}
      is (B8.U)   {w_nbyte := 8.U}
      is (B16.U)  {w_nbyte := 16.U}
    }

    return w_nbyte
  }

  def toMask(nDataByte: Int, size: UInt): UInt = {
    val w_mask = Wire(Vec(nDataByte, Bool())) 

    for (db <- 0 until nDataByte) {
      w_mask(db) := (db.U < toByte(size))
    }

    return w_mask.asUInt
  }
}

object MBUS {
  def node (p: Array[MBusParams]) : MBusParams = {
    return new MBusConfig (
      isSim = {
        var tmp: Boolean = p(0).isSim
        for (s <- 1 until p.size) {
          if (p(s).isSim == true) {
            tmp = true
          }
        }
        tmp 
      },
      
      readOnly = {
        var tmp: Boolean = p(0).readOnly
        for (s <- 1 until p.size) {
          if (p(s).readOnly == false) {
            tmp = false
          }
        }
        tmp 
      },
      nAddrBit = {
        var tmp: Int = p(0).nAddrBit
        for (s <- 1 until p.size) {
          if (p(s).nAddrBit > tmp) {
            tmp = p(s).nAddrBit
            println("Warning: all masters have not the same number of address bits.")
          }
        }
        tmp
      },
      nDataByte = {
        var tmp: Int = p(0).nDataByte
        for (s <- 1 until p.size) {
          if (p(s).nDataByte > tmp) {
            tmp = p(s).nDataByte
          }
        }
        tmp
      }
    )
  }
}

object NODE {
  def NBIT  = 2
  def X     = 0.U(NBIT.W)

  def R     = 0.U(NBIT.W)
  def W     = 1.U(NBIT.W)
}
