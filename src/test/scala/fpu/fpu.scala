/*
 * File: fpu.scala                                                             *
 * Created Date: 2023-12-20 04:07:21 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2024-02-06 11:35:25 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2024 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.fpu

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec


class FpuTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "Fpu"
  // test class body here
  "Fpu test" should "pass" in {
    // test case body here
    test(new Fpu(FpuConfigBase)).withAnnotations (Seq( /*VerilatorBackendAnnotation,*/ WriteVcdAnnotation )){ dut =>
      // test body here
      dut.io.b_pipe.req.valid.poke(false.B)
      dut.io.b_pipe.ack.ready.poke(true.B)
      dut.clock.step(5)

      dut.io.b_pipe.req.valid.poke(true.B)
	    dut.io.b_pipe.req.ctrl.get.code.poke(CODE.MVWX)
	    dut.io.b_pipe.req.ctrl.get.op(0).poke(OP.INT)
	    dut.io.b_pipe.req.ctrl.get.op(1).poke(OP.X)
	    dut.io.b_pipe.req.ctrl.get.op(2).poke(OP.X)
	    dut.io.b_pipe.req.ctrl.get.rs(0).poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.rs(1).poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.rs(2).poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.rd.poke(1.U)
	    dut.io.b_pipe.req.ctrl.get.wb.poke(false.B)
	    dut.io.b_pipe.req.data.get.src(0).poke("b0_01111111_00000000000000000000000".U)
	    dut.io.b_pipe.req.data.get.src(1).poke("b0_00000000_00000000000000000000000".U)
	    dut.io.b_pipe.req.data.get.src(2).poke("b0_00000000_00000000000000000000000".U)
      dut.clock.step(1)

      dut.io.b_pipe.req.valid.poke(true.B)
	    dut.io.b_pipe.req.ctrl.get.code.poke(CODE.MVWX)
	    dut.io.b_pipe.req.ctrl.get.op(0).poke(OP.INT)
	    dut.io.b_pipe.req.ctrl.get.op(1).poke(OP.X)
	    dut.io.b_pipe.req.ctrl.get.op(2).poke(OP.X)
	    dut.io.b_pipe.req.ctrl.get.rs(0).poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.rs(1).poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.rs(2).poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.rd.poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.wb.poke(false.B)
	    dut.io.b_pipe.req.data.get.src(0).poke("b0_01111111_00000000000000000000000".U)
	    dut.io.b_pipe.req.data.get.src(1).poke("b0_00000000_00000000000000000000000".U)
	    dut.io.b_pipe.req.data.get.src(2).poke("b0_00000000_00000000000000000000000".U)
      dut.clock.step(1)

      dut.io.b_pipe.req.valid.poke(true.B)
	    dut.io.b_pipe.req.ctrl.get.code.poke(CODE.ADD)
	    dut.io.b_pipe.req.ctrl.get.op(0).poke(OP.FLOAT)
	    dut.io.b_pipe.req.ctrl.get.op(1).poke(OP.FLOAT)
	    dut.io.b_pipe.req.ctrl.get.op(2).poke(OP.X)
	    dut.io.b_pipe.req.ctrl.get.rs(0).poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.rs(1).poke(1.U)
	    dut.io.b_pipe.req.ctrl.get.rs(2).poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.rd.poke(2.U)
	    dut.io.b_pipe.req.ctrl.get.wb.poke(false.B)
	    dut.io.b_pipe.req.data.get.src(0).poke("b0_00000000_00000000000000000000000".U)
	    dut.io.b_pipe.req.data.get.src(1).poke("b0_00000000_00000000000000000000000".U)
	    dut.io.b_pipe.req.data.get.src(2).poke("b0_00000000_00000000000000000000000".U)
      dut.clock.step(4)

      dut.io.b_pipe.req.valid.poke(true.B)
	    dut.io.b_pipe.req.ctrl.get.code.poke(CODE.MVWX)
	    dut.io.b_pipe.req.ctrl.get.op(0).poke(OP.INT)
	    dut.io.b_pipe.req.ctrl.get.op(1).poke(OP.X)
	    dut.io.b_pipe.req.ctrl.get.op(2).poke(OP.X)
	    dut.io.b_pipe.req.ctrl.get.rs(0).poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.rs(1).poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.rs(2).poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.rd.poke(3.U)
	    dut.io.b_pipe.req.ctrl.get.wb.poke(false.B)
	    dut.io.b_pipe.req.data.get.src(0).poke("b0_01111111_11000000000000000000000".U)
	    dut.io.b_pipe.req.data.get.src(1).poke("b0_00000000_00000000000000000000000".U)
	    dut.io.b_pipe.req.data.get.src(2).poke("b0_00000000_00000000000000000000000".U)
      dut.clock.step(1)

      dut.io.b_pipe.req.valid.poke(true.B)
	    dut.io.b_pipe.req.ctrl.get.code.poke(CODE.ADD)
	    dut.io.b_pipe.req.ctrl.get.op(0).poke(OP.FLOAT)
	    dut.io.b_pipe.req.ctrl.get.op(1).poke(OP.FLOAT)
	    dut.io.b_pipe.req.ctrl.get.op(2).poke(OP.X)
	    dut.io.b_pipe.req.ctrl.get.rs(0).poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.rs(1).poke(3.U)
	    dut.io.b_pipe.req.ctrl.get.rs(2).poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.rd.poke(4.U)
	    dut.io.b_pipe.req.ctrl.get.wb.poke(false.B)
	    dut.io.b_pipe.req.data.get.src(0).poke("b0_00000000_00000000000000000000000".U)
	    dut.io.b_pipe.req.data.get.src(1).poke("b0_00000000_00000000000000000000000".U)
	    dut.io.b_pipe.req.data.get.src(2).poke("b0_00000000_00000000000000000000000".U)
      dut.clock.step(4)

      dut.io.b_pipe.req.valid.poke(true.B)
	    dut.io.b_pipe.req.ctrl.get.code.poke(CODE.SUB)
	    dut.io.b_pipe.req.ctrl.get.op(0).poke(OP.FLOAT)
	    dut.io.b_pipe.req.ctrl.get.op(1).poke(OP.FLOAT)
	    dut.io.b_pipe.req.ctrl.get.op(2).poke(OP.X)
	    dut.io.b_pipe.req.ctrl.get.rs(0).poke(4.U)
	    dut.io.b_pipe.req.ctrl.get.rs(1).poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.rs(2).poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.rd.poke(0.U)
	    dut.io.b_pipe.req.ctrl.get.wb.poke(false.B)
	    dut.io.b_pipe.req.data.get.src(0).poke("b0_00000000_00000000000000000000000".U)
	    dut.io.b_pipe.req.data.get.src(1).poke("b0_00000000_00000000000000000000000".U)
	    dut.io.b_pipe.req.data.get.src(2).poke("b0_00000000_00000000000000000000000".U)
      dut.clock.step(4)

      dut.io.b_pipe.req.valid.poke(false.B)
      dut.clock.step(10)
    }
  }
}