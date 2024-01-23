/*
 * File: configs.scala                                                         *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 01:42:02 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.common.ram

import chisel3._
import chisel3.util._

import prj.common.mbus._


object RamCtrlConfigBase extends RamCtrlConfig (
  nPort = 2,

  isSim = true, 

  isRom = false,
  nByte = "100",
  nDataByte = 4
)

object MBusCtrlConfigBase extends MBusCtrlConfig (
  pPort = MBusConfig0,

  isSim = true, 

  isRom = false,
  useReqReg = false
)

object MBusRamConfigBase extends MBusRamConfig (
  pPort = Array(MBusConfig0, MBusConfig1),
  
  isSim = true,

  initFile = "",
  isRom = false,
  nAddrBase = "0000",
  nByte = "100",
  
  useReqReg = false
)