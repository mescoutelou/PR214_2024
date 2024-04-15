/*
 * File: configs.scala                                                         *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-15 09:50:35 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 HerdWare                                                 *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.betizu

import chisel3._
import chisel3.util._
import scala.math._


object BetizuConfigBase extends BetizuConfig (
  isSim = true, 

  pcBoot = "04000000",

  useL0IBuffer = true,
  nL0IBufferDepth = 2,
  useIfStage = true,

  usePack = true,
  nExBufferDepth = 2,
  useFpu = true,
  useGprBypass = true
)