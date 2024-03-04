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


package prj.common.lbus

import chisel3._
import chisel3.util._
import scala.math._


object LBusConfig0 extends LBusConfig (
  isSim = true,  

  readOnly = false,
  nAddrBit = 32,
  nDataByte = 4
) 

object LBusConfig1 extends LBusConfig (
  isSim = true,  

  readOnly = true,
  nAddrBit = 32,
  nDataByte = 8
)

object LBusMBusConfig0 extends LBusMBusConfig (
  pLBus = LBusConfig0,
  nRBufferDepth = 1,
  nWBufferDepth = 1
)