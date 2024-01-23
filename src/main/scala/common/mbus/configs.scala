/*
 * File: configs.scala                                                         *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 12:14:34 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.common.mbus

import chisel3._
import chisel3.util._
import scala.math._


// ******************************
//              BUS
// ******************************
object MBusConfig0 extends MBusConfig (
  isSim = true,  

  readOnly = false,
  nAddrBit = 32,
  nDataByte = 4
) 

object MBusConfig1 extends MBusConfig (
  isSim = true,  

  readOnly = true,
  nAddrBit = 32,
  nDataByte = 8
)

// ******************************
//            MEMORY
// ******************************
object MBusMemConfig0 extends MBusMemConfig (
  pPort = Array(MBusConfig0),
  nAddrBase = "00",
  nByte = "10"
)

object MBusMemConfig1 extends MBusMemConfig (
  pPort = Array(MBusConfig1),
  nAddrBase = "10",
  nByte = "30"
)

object MBusMemConfig2 extends MBusMemConfig (
  pPort = Array(MBusConfig0),
  nAddrBase = "40",
  nByte = "10"
)

// ******************************
//          INTERCONNECT
// ******************************
object MBusCrossbarConfigBase extends MBusCrossbarConfig (
  pMaster = Array(MBusConfig0, MBusConfig1, MBusConfig0),
  useMem = false,
  pMem = Array(MBusMemConfig0, MBusMemConfig1),
  nDefault = 1,
  nBus = 3,
  
  isSim = true,  
  
  nDepth = 2,
  useDirect = false
)