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


// package emmk.top
// 
// import chisel3._
// import chisel3.util._
// 
// import emmk.common.mbus._
// import emmk.common.ram._
// import emmk.core._
// import emmk.fpu._
// 
// trait TopParams {
// 	def isSim: Boolean
// 
// 	def pcBoot: String
// 
// 	def nAddrBit: Int
// 
// 	def pCore: CoreParams = new CoreConfig (
// 		isSim = isSim,
//   	pcBoot = pcBoot,
// 		useIfStage = true
// 	)
// 
// 	def pFpu: FpuParams = new FpuConfig (
// 		isSim = isSim,
// 		nAddrBit = nAddrBit,
// 		useShiftStage = true,
// 		useExStage = true
// 	)
// 
//   def pBPort: Array[MBusParams] = {
//     var pb = Array[MBusParams]()
// 
//     pb = pb :+ pCore.pL0DBus
//     pb = pb :+ pCore.pL0IBus
// //    pb = pb :+ pFpu.pDBus
// 
//     return pb
//   }
//   def nBPort: Int = pBPort.size
//   def pBus: MBusParams = MBUS.node(pBPort)
// 
// 	def pRom: MBusRamParams = new MBusRamConfig (
// 		pPort = Array(pBus),
// 
// 		isSim = isSim,
// 
// 		initFile = "",
// 		isRom = true,
// 		nAddrBase = "04000000",
// 		nByte = "00040000",
// 		useReqReg = false
// 	)
// 
// 	def pRam: MBusRamParams = new MBusRamConfig (
// 		pPort = Array(pBus),
// 
// 		isSim = isSim,
// 
// 		initFile = "",
// 		isRom = false,
// 		nAddrBase = "08000000",
// 		nByte = "00040000",
// 		useReqReg = false
// 	)
// 	
//   def pBusCross: MBusCrossbarParams = new MBusCrossbarConfig (
//     pMaster = pBPort                    ,
//     useMem = true                       ,
//     pMem        = {
//       var pmem = Array[MBusMemParams]()
//       pmem = pmem :+ pRom
//       pmem = pmem :+ pRam
//       pmem
//     }                                   ,
//     nDefault = 0                        ,
//     nBus = 0                            ,
//     
//     isSim = isSim                       ,  
// 
//     nDepth = 4                          ,
//     useDirect = false
//   )
// }
// 
// case class TopConfig (
// 	isSim: Boolean, 
// 
// 	pcBoot: String,
// 	
// 	nAddrBit: Int
// ) extends TopParams
