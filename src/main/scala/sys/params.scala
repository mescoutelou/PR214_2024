/*
 * File: params.scala                                                          *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-04-08 02:30:48 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.sys

import chisel3._
import chisel3.util._

import prj.common.mbus._
import prj.common.ram._
import prj.betizu._
import prj.fpu._

trait SysParams {
	def isSim: Boolean

	def pcBoot: String

	def nAddrBit: Int

	def pBetizu: BetizuParams = new BetizuConfig (
		isSim = isSim,
  	pcBoot = pcBoot,
		useIfStage = true
	)

	def pFpu: FpuParams = new FpuConfig (
		isSim = isSim,
		nAddrBit = nAddrBit,
		useShiftStage = true,
		useExStage = true
	)

  def pBPort: Array[MBusParams] = {
    var pb = Array[MBusParams]()

    pb = pb :+ pBetizu.pL0DBus
    pb = pb :+ pBetizu.pL0IBus
//    pb = pb :+ pFpu.pDBus

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

	pcBoot: String,
	
	nAddrBit: Int
) extends SysParams
