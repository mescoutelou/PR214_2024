/*
 * File: params.scala                                                          *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-15 09:52:39 am                                       *
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

import emmk.common.mbus._
import emmk.common.ram._
import emmk.betizu._
import emmk.fpu._

trait SysParams {
	def isSim: Boolean

	def pBetizu: BetizuParams
	def useFpu: Boolean
	def pFpu: FpuParams

  def pBPort: Array[MBusParams] = {
    var pb = Array[MBusParams]()

    if (useFpu) pb = pb :+ pFpu.pDBus
    pb = pb :+ pBetizu.pL0DBus
    pb = pb :+ pBetizu.pL0IBus

    return pb
  }
  def nBPort: Int = pBPort.size
  def pBus: MBusParams = MBUS.node(pBPort)

	def pRom: MBusRamParams = new MBusRamConfig (
		pPort = Array(pBus),

		isSim = isSim,

		initFile = "",
		isRom = true,
		nAddrBase = "04000000",
		nByte = "00040000",
		useReqReg = false
	)

	def pRam: MBusRamParams = new MBusRamConfig (
		pPort = Array(pBus),

		isSim = isSim,

		initFile = "",
		isRom = false,
		nAddrBase = "08000000",
		nByte = "00040000",
		useReqReg = false
	)
	
  def pBusCross: MBusCrossbarParams = new MBusCrossbarConfig (
    pMaster = pBPort                    ,
    useMem = true                       ,
    pMem        = {
      var pmem = Array[MBusMemParams]()
      pmem = pmem :+ pRom
      pmem = pmem :+ pRam
      pmem
    }                                   ,
    nDefault = 0                        ,
    nBus = 0                            ,
    
    isSim = isSim                       ,  

    nDepth = 4                          ,
    useDirect = false
  )
}

case class SysConfig (
	isSim: Boolean, 

	pBetizu: BetizuParams,
	useFpu: Boolean,
	pFpu: FpuParams
) extends SysParams
