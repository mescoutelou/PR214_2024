/*
 * File: configs.scala                                                         *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-15 09:55:22 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 HerdWare                                                 *
 * -----                                                                       *
 * Description:                                                                *
 */


package emmk.sys

import chisel3._
import chisel3.util._

import emmk.betizu.{BetizuConfig}
import emmk.fpu.{FpuConfig}


object SysConfigBase extends SysConfig (
	isSim = true, 

	pBetizu = new BetizuConfig (
  	isSim = true, 

  	pcBoot = "04000000",

  	useL0IBuffer = true,
  	nL0IBufferDepth = 2,
  	useIfStage = true,

  	usePack = true,
  	nExBufferDepth = 2,
  	useFpu = true,
  	useGprBypass = true
	),

	useFpu = true,
	pFpu = new FpuConfig (
		isSim = true, 

		nAddrBit = 32,

		useShiftStage = true,
		useExStage = true
	)
)