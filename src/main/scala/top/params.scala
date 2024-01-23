/*
 * File: params.scala                                                          *
 * Created Date: 2023-12-20 03:19:35 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 02:30:22 pm                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.top

import chisel3._
import chisel3.util._

import prj.common.mbus._
import prj.common.ram._
import prj.core._
import prj.fpu._

trait TopParams {
	def isSim: Boolean

	def nAddrBit: Int

	def pCore: CoreParams = new CoreConfig (
		isSim = isSim,
		nAddrBit = nAddrBit
	)

	def pFpu: FpuParams = new FpuConfig (
		isSim = isSim,
		nAddrBit = nAddrBit
	)

  def pBPort: Array[MBusParams] = {
    var pb = Array[MBusParams]()

    pb = pb :+ pCore.pDBus
    pb = pb :+ pCore.pIBus
    pb = pb :+ pFpu.pDBus

    return pb
  }
  def nBPort: Int = pBPort.size
  def pBus: MBusParams = MBUS.node(pBPort)

	def pIMem: MBusRamParams = new MBusRamConfig (
		pPort = Array(pBus),

		isSim = isSim,

		initFile = "",
		isRom = true,
		nAddrBase = "04000000",
		nByte = "00040000",
		useReqReg = false
	)

	def pDMem: MBusRamParams = new MBusRamConfig (
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
      pmem = pmem :+ pIMem
      pmem = pmem :+ pDMem
      pmem
    }                                   ,
    nDefault = 0                        ,
    nBus = 0                            ,
    
    isSim = isSim                       ,  

    nDepth = 4                          ,
    useDirect = false
  )
}

case class TopConfig (
	isSim: Boolean, 
	
	nAddrBit: Int
) extends TopParams
