/*
 * File: cross.scala                                                           *
 * Created Date: 2023-02-25 12:54:02 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-01-23 12:14:38 pm                                       *
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

import emmk.common.gen._


class MBusCrossbarReq (p: MBusCrossbarParams) extends Module {
  require ((p.useMem || (p.nMaster >= p.nSlave)), "Number of masters must be greater or equal than the number of slaves.")
  
  val io = IO(new Bundle {
    val b_m = MixedVec(
      for (ma <- p.pMaster) yield {
        val port = Flipped(new MBusReqIO(ma))
        port
      }
    )
    val b_s = Vec(p.nSlave, new MBusReqIO(p.pSlave))
    
    val b_mnode = Vec(p.nMaster, new GenRVIO(p, new MBusNodeBus(p.nSlave), UInt(0.W)))
    val b_snode = Vec(p.nSlave, new GenRVIO(p, new MBusNodeBus(p.nMaster), UInt(0.W)))
  })

  val w_addr = Wire(Vec(p.nMaster, UInt(p.nAddrBit.W)))
  val w_mem = Wire(Vec(p.nMaster, Vec(p.nMem, Bool())))
  val w_def = Wire(Vec(p.nMaster, Vec(p.nDefault, Bool())))
  val w_zero = Wire(Vec(p.nMaster, Bool()))
  val w_slave = Wire(Vec(p.nMaster, Vec(p.nSlave, Bool())))
  val w_mreq = Wire(Vec(p.nMaster, Vec(p.nSlave, Bool())))
  val w_sreq = Wire(Vec(p.nSlave, Vec(p.nMaster, Bool())))
  val w_mnode = Wire(Vec(p.nMaster, UInt(log2Ceil(p.nSlave).W)))
  val w_snode = Wire(Vec(p.nSlave, UInt(log2Ceil(p.nMaster).W)))

  // ******************************
  //            MEMORY
  // ******************************
  w_slave := DontCare
  
  for (ma <- 0 until p.nMaster) {
    for (me <- 0 until p.nMem) {
      w_mem(ma)(me) := (w_addr(ma) >= BigInt(p.pMem(me).nAddrBase, 16).U) & (w_addr(ma) < (BigInt(p.pMem(me).nAddrBase, 16) + BigInt(p.pMem(me).nByte, 16)).U)
      w_slave(ma)(me) := w_mem(ma)(me)
    }

    for (d <- 0 until p.nDefault) {
      w_def(ma)(d) := ~w_mem(ma).asUInt.orR
      w_slave(ma)(p.nMem + d) := w_def(ma)(d)
    }

    w_zero(ma) := ~w_slave(ma).asUInt.orR
  }

  // ******************************
  //            DEFAULT
  // ******************************
  for (ma <- 0 until p.nMaster) {
    io.b_m(ma) := DontCare
    io.b_m(ma).ready := false.B    

    io.b_mnode(ma) := DontCare
    io.b_mnode(ma).valid := false.B      
  }

  for (s <- 0 until p.nSlave) {
    io.b_s(s) := DontCare
    io.b_s(s).valid := false.B

    io.b_snode(s) := DontCare
    io.b_snode(s).valid := false.B      
  }    

  // ******************************
  //            ADDRESS
  // ******************************
  for (ma <- 0 until p.nMaster) {
    w_addr(ma) := io.b_m(ma).ctrl.addr
  }

  // ******************************
  //            SELECT
  // ******************************
  for (ma <- 0 until p.nMaster) {
    for (s <- 0 until p.nSlave) {
      if (p.useMem) {
        w_mreq(ma)(s) := io.b_m(ma).valid & w_slave(ma)(s)
      } else {
        w_mreq(ma)(s) := io.b_m(ma).valid   
      }
    }
  }

  for (ma0 <- 0 until p.nMaster) {
    for (s0 <- 0 until p.nSlave) {
      for (s1 <- (s0 + 1) until p.nSlave) {
        when (w_mreq(ma0)(s0)) {
          w_mreq(ma0)(s1) := false.B
        }
      }
      for (ma1 <- (ma0 + 1) until p.nMaster) {
        when (w_mreq(ma0)(s0)) {
          w_mreq(ma1)(s0) := false.B
        }
      }
    }
  }

  for (ma <- 0 until p.nMaster) {
    w_mnode(ma) := PriorityEncoder(w_mreq(ma).asUInt)
  }

  for (s <- 0 until p.nSlave) {
    for (ma <- 0 until p.nMaster) {
      w_sreq(s)(ma) := w_mreq(ma)(s)
    }
    w_snode(s) := PriorityEncoder(w_sreq(s).asUInt)
  }
  
  // ******************************
  //            CONNECT
  // ******************************
  for (ma <- 0 until p.nMaster) {
    // Default if no mem
    if (p.useMem) {
      when (w_zero(ma)) {
        io.b_m(ma).ready := io.b_mnode(ma).ready
      }
    }

    // Normal
    for (s <- 0 until p.nSlave) {
      when ((ma.U === w_snode(s)) & w_sreq(s)(ma)) {
        io.b_m(ma).ready := io.b_s(s).ready & io.b_snode(s).ready & io.b_mnode(ma).ready

        io.b_s(s).valid := io.b_snode(s).ready & io.b_mnode(ma).ready
        io.b_s(s).ctrl.rw := io.b_m(ma).ctrl.rw
        io.b_s(s).ctrl.size := io.b_m(ma).ctrl.size
        io.b_s(s).ctrl.addr := io.b_m(ma).ctrl.addr
      }
    }
  }

  // ******************************
  //             NODE
  // ******************************  
  for (ma <- 0 until p.nMaster) {
    // Default if no mem
    if (p.useMem) {
      when (io.b_m(ma).valid & w_zero(ma)) {
        io.b_mnode(ma).valid := true.B
        if (!p.readOnly) io.b_mnode(ma).ctrl.get.rw := io.b_m(ma).ctrl.rw
        io.b_mnode(ma).ctrl.get.zero := true.B
      }        
    }

    // Normal
    for (s <- 0 until p.nSlave) {
      when (w_mreq(ma).asUInt.orR & (ma.U === w_snode(s)) & (s.U === w_mnode(ma))) {
        io.b_mnode(ma).valid := io.b_s(s).ready & io.b_snode(s).ready
        if (!p.readOnly) io.b_mnode(ma).ctrl.get.rw := io.b_m(ma).ctrl.rw
        io.b_mnode(ma).ctrl.get.zero := false.B
        io.b_mnode(ma).ctrl.get.node := w_mnode(ma)

        io.b_snode(s).valid := io.b_s(s).ready & io.b_mnode(ma).ready
        if (!p.readOnly) io.b_snode(s).ctrl.get.rw := io.b_m(ma).ctrl.rw
        io.b_snode(s).ctrl.get.node := w_snode(s)
      }        
    }
  } 

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    dontTouch(io.b_snode)
    dontTouch(io.b_mnode)
  } 
}

class MBusCrossbarWrite (p: MBusCrossbarParams) extends Module {
  val io = IO(new Bundle {
    val b_m = MixedVec(
      for (ma <- p.pMaster) yield {
        val port = Flipped(new MBusDataIO(ma))
        port
      }
    )
    val b_s = Vec(p.nSlave, new MBusDataIO(p.pSlave))

    val b_mnode = Vec(p.nMaster, Flipped(new GenRVIO(p, new MBusNodeBus(p.nSlave), UInt(0.W))))
    val b_snode = Vec(p.nSlave, Flipped(new GenRVIO(p, new MBusNodeBus(p.nMaster), UInt(0.W))))
  })

  val w_mnode = Wire(Vec(p.nMaster, UInt(log2Ceil(p.nSlave).W)))
  val w_snode = Wire(Vec(p.nSlave, UInt(log2Ceil(p.nMaster).W)))
    
  // ******************************
  //            DEFAULT
  // ******************************
  for (ma <- 0 until p.nMaster) {
    io.b_m(ma).ready := false.B   

    io.b_mnode(ma).ready := false.B        
  }

  for (s <- 0 until p.nSlave) {
    io.b_s(s).valid := false.B
    io.b_s(s).data := io.b_m(0).data

    io.b_snode(s).ready := false.B
  }

  // ******************************
  //             NODE
  // ******************************
  for (ma <- 0 until p.nMaster) {
    w_mnode(ma) := io.b_mnode(ma).ctrl.get.node
  }

  for (s <- 0 until p.nSlave) {
    w_snode(s) := io.b_snode(s).ctrl.get.node
  }

  // ******************************
  //            CONNECT
  // ******************************
  if (!p.readOnly) { 
    for (ma <- 0 until p.nMaster) {
      when (io.b_mnode(ma).ctrl.get.rw) {
        // Default if no mem
        if (p.useMem) {
          when (io.b_mnode(ma).ctrl.get.zero) {
            io.b_m(ma).ready := io.b_mnode(ma).valid
            io.b_mnode(ma).ready := io.b_m(ma).valid
          }
        }

        // Normal
        for (s <- 0 until p.nSlave) {
          when ((ma.U === w_snode(s)) & (s.U === w_mnode(ma)) & ~io.b_mnode(ma).ctrl.get.zero) {
            when (io.b_mnode(ma).valid & io.b_snode(s).valid) {
              io.b_m(ma).ready := io.b_s(s).ready

              io.b_s(s).valid := io.b_m(ma).valid
              io.b_s(s).data := io.b_m(ma).data
            }

            io.b_mnode(ma).ready := io.b_m(ma).valid & io.b_s(s).ready & io.b_snode(s).valid
            io.b_snode(s).ready := io.b_m(ma).valid & io.b_s(s).ready & io.b_mnode(ma).valid
          }            
        }
      } 
    }
  }

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    dontTouch(io.b_mnode)  
    dontTouch(io.b_snode)    
  } 
}

class MBusCrossbarRead (p: MBusCrossbarParams) extends Module {
  val io = IO(new Bundle {
    val b_m = MixedVec(
      for (ma <- p.pMaster) yield {
        val port = new MBusDataIO(ma)
        port
      }
    )
    val b_s = Vec(p.nSlave, Flipped(new MBusDataIO(p.pSlave)))

    val b_mnode = Vec(p.nMaster, Flipped(new GenRVIO(p, new MBusNodeBus(p.nSlave), UInt(0.W))))
    val b_snode = Vec(p.nSlave, Flipped(new GenRVIO(p, new MBusNodeBus(p.nMaster), UInt(0.W))))
  })

  val w_mnode = Wire(Vec(p.nMaster, UInt(log2Ceil(p.nSlave).W)))
  val w_snode = Wire(Vec(p.nSlave, UInt(log2Ceil(p.nMaster).W)))
  
  
  // ******************************
  //            DEFAULT
  // ******************************
  for (ma <- 0 until p.nMaster) {
    io.b_m(ma).valid := false.B
    io.b_m(ma).data := io.b_s(0).data

    io.b_mnode(ma).ready := false.B        
  }

  for (s <- 0 until p.nSlave) {
    io.b_s(s).ready := false.B   

    io.b_snode(s).ready := false.B
  }

  // ******************************
  //             NODE
  // ******************************
  for (ma <- 0 until p.nMaster) {
    w_mnode(ma) := io.b_mnode(ma).ctrl.get.node
  }

  for (s <- 0 until p.nSlave) {
    w_snode(s) := io.b_snode(s).ctrl.get.node
  }

  // ******************************
  //            CONNECT
  // ******************************
  for (ma <- 0 until p.nMaster) {
    when (~io.b_mnode(ma).ctrl.get.rw) {
      // Default if no mem
      if (p.useMem) {
        when (io.b_mnode(ma).ctrl.get.zero) {
          io.b_m(ma).valid := io.b_mnode(ma).valid
          io.b_mnode(ma).ready := io.b_m(ma).ready
        }
      }

      // Normal
      for (s <- 0 until p.nSlave) {
        when ((ma.U === w_snode(s)) & (s.U === w_mnode(ma)) & ~io.b_mnode(ma).ctrl.get.zero) {
          when (io.b_snode(s).valid & io.b_mnode(ma).valid) {
            io.b_m(ma).valid := io.b_s(s).valid
            io.b_m(ma).data := io.b_s(s).data

            io.b_s(s).ready := io.b_m(ma).ready
          }
          io.b_mnode(ma).ready := io.b_m(ma).ready & io.b_s(s).valid & io.b_snode(s).valid
          io.b_snode(s).ready := io.b_m(ma).ready & io.b_s(s).valid & io.b_mnode(ma).valid
        }            
      }
    } 
  }   

  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    dontTouch(io.b_mnode)  
    dontTouch(io.b_snode)    
  } 
}

class MBusCrossbar (p: MBusCrossbarParams) extends Module {
  val io = IO(new Bundle {   
    val b_m = MixedVec(
      for (ma <- p.pMaster) yield {
        val port = Flipped(new MBusIO(ma))
        port
      }
    )
    val b_s = Vec(p.nSlave, new MBusIO(p.pSlave))
  })

  val m_req = Module(new MBusCrossbarReq(p))
  val m_mnode = Seq.fill(p.nMaster){Module(new GenFifo(p, new MBusNodeBus(p.nSlave), UInt(0.W), 3, p.nDepth, 1, 1))}
  val m_snode = Seq.fill(p.nSlave){Module(new GenFifo(p, new MBusNodeBus(p.nMaster), UInt(0.W), 3, p.nDepth, 1, 1))}
  val m_write = Module(new MBusCrossbarWrite(p))
  val m_read = Module(new MBusCrossbarRead(p))  
  
  // ******************************
  //            MASTER
  // ******************************
  for (ma <- 0 until p.nMaster) {
    m_req.io.b_m(ma) <> io.b_m(ma).req
    m_write.io.b_m(ma) <> io.b_m(ma).write
    m_read.io.b_m(ma) <> io.b_m(ma).read
  }

  // ******************************
  //             SLAVE
  // ******************************
  for (s <- 0 until p.nSlave) {
    m_req.io.b_s(s) <> io.b_s(s).req
    m_write.io.b_s(s) <> io.b_s(s).write
    m_read.io.b_s(s) <> io.b_s(s).read
  }

  // ******************************
  //             NODE
  // ******************************
  // ------------------------------
  //            MASTER
  // ------------------------------
  for (ma <- 0 until p.nMaster) {
    m_mnode(ma).io.i_flush := false.B    

    m_mnode(ma).io.b_in(0) <> m_req.io.b_mnode(ma)
    m_write.io.b_mnode(ma) <> m_mnode(ma).io.b_out(0)
    m_read.io.b_mnode(ma) <> m_mnode(ma).io.b_out(0)

    m_write.io.b_mnode(ma).valid := m_mnode(ma).io.b_out(0).valid & m_mnode(ma).io.b_out(0).ctrl.get.rw
    m_read.io.b_mnode(ma).valid := m_mnode(ma).io.b_out(0).valid & ~m_mnode(ma).io.b_out(0).ctrl.get.rw
    m_mnode(ma).io.b_out(0).ready := (~m_mnode(ma).io.b_out(0).ctrl.get.rw | m_write.io.b_mnode(ma).ready) & (m_mnode(ma).io.b_out(0).ctrl.get.rw | m_read.io.b_mnode(ma).ready)
  }

  // ------------------------------
  //             SLAVE
  // ------------------------------
  for (s <- 0 until p.nSlave) {
    m_snode(s).io.i_flush := false.B    

    m_snode(s).io.b_in(0) <> m_req.io.b_snode(s)
    m_write.io.b_snode(s) <> m_snode(s).io.b_out(0)
    m_read.io.b_snode(s) <> m_snode(s).io.b_out(0)

    m_write.io.b_snode(s).valid := m_snode(s).io.b_out(0).valid & m_snode(s).io.b_out(0).ctrl.get.rw
    m_read.io.b_snode(s).valid := m_snode(s).io.b_out(0).valid & ~m_snode(s).io.b_out(0).ctrl.get.rw
    m_snode(s).io.b_out(0).ready := (~m_snode(s).io.b_out(0).ctrl.get.rw | m_write.io.b_snode(s).ready) & (m_snode(s).io.b_out(0).ctrl.get.rw | m_read.io.b_snode(s).ready)
  }
  
  // ******************************
  //          DIRECT CONNECT
  // ******************************
  if (p.useDirect && !p.useMem && (p.nMaster == p.nSlave)) {
    for (s <- 0 until p.nSlave) {
      io.b_m(s) <> io.b_s(s)
    }    
  }

  // ******************************
  //            REPORT
  // ******************************
  def report (name: String): Unit = {
    println("------------------------------")
    println("Crossbar: " + name)
    println("Data size: " + p.nDataBit)
    if (p.useMem) {
      for (me <- 0 until p.nMem) {
        var v_start: String = "%08x".format(BigInt(p.pMem(me).nAddrBase, 16))
        var v_end: String = "%08x".format(BigInt(p.pMem(me).nAddrBase, 16) + BigInt(p.pMem(me).nByte, 16))

        if (p.nAddrBit > 32) {
          v_start = v_start.takeRight(16)
          v_end = v_end.takeRight(16)
        } else {
          v_start = v_start.takeRight(8)
          v_end = v_end.takeRight(8)
        }

        println(("Range " + me + ": 0x" + v_start + " | 0x" + v_end))
      }

      for (d <- 0 until p.nDefault) {
        var v_start: String = ""
        var v_end: String = ""

        if (p.nAddrBit == 64) {
          v_start = "0000000000000000"
          v_end = "ffffffffffffffff"
        } else {
          v_start = "00000000"
          v_end = "ffffffff"
        }

        println(("Range " + (p.nMem + d) + ": 0x" + v_start + " | 0x" + v_end))
      }
    }
    println("------------------------------")
  }


  // ******************************
  //           SIMULATION
  // ******************************
  if (p.isSim) {
    
  } 
}

object MBusCrossbarReq extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new MBusCrossbarReq(MBusCrossbarConfigBase),
    firtoolOpts = Array.concat(
      Array(
        "--disable-all-randomization",
        "--strip-debug-info",
        "--split-verilog"
      ),
      args
    )      
  )
}

object MBusCrossbarWrite extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new MBusCrossbarWrite(MBusCrossbarConfigBase),
    firtoolOpts = Array.concat(
      Array(
        "--disable-all-randomization",
        "--strip-debug-info",
        "--split-verilog"
      ),
      args
    )      
  )
}

object MBusCrossbarRead extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new MBusCrossbarRead(MBusCrossbarConfigBase),
    firtoolOpts = Array.concat(
      Array(
        "--disable-all-randomization",
        "--strip-debug-info",
        "--split-verilog"
      ),
      args
    )      
  )
}

object MBusCrossbar extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new MBusCrossbar(MBusCrossbarConfigBase),
    firtoolOpts = Array.concat(
      Array(
        "--disable-all-randomization",
        "--strip-debug-info",
        "--split-verilog"
      ),
      args
    )      
  )
}