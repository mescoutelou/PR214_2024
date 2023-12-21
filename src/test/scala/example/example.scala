/*
 * File: example.scala                                                         *
 * Created Date: 2023-12-20 04:07:21 pm                                        *
 * Author: Mathieu Escouteloup                                                 *
 * -----                                                                       *
 * Last Modified: 2023-12-21 07:27:53 am                                       *
 * Modified By: Mathieu Escouteloup                                            *
 * Email: mathieu.escouteloup@ims-bordeaux.com                                 *
 * -----                                                                       *
 * License: See LICENSE.md                                                     *
 * Copyright (c) 2023 ENSEIRB-MATMECA                                          *
 * -----                                                                       *
 * Description:                                                                *
 */


package prj.example

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec


class ExampleTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "Example"
  // test class body here
  "Example test" should "pass" in {
    // test case body here
    test(new Example(32)).withAnnotations (Seq( /*VerilatorBackendAnnotation,*/ WriteVcdAnnotation )){ dut =>
      // test body here
      dut.io.i_s1.poke(1.U)
      dut.io.i_s2.poke(1.U)
      dut.clock.step()
      dut.clock.step()
    }
  }

  "Example test 2" should "pass" in {
    // test case body here
    test(new Example(32)).withAnnotations (Seq( /*VerilatorBackendAnnotation,*/ WriteVcdAnnotation )){ dut =>
      // test body here
      dut.io.i_s1.poke(1.U)
      dut.io.i_s2.poke(4.U)
      dut.clock.step(20)
    }
  }

  "Example test 3" should "pass" in {
    // test case body here
    test(new Example(32)).withAnnotations (Seq( /*VerilatorBackendAnnotation,*/ WriteVcdAnnotation )){ dut =>
      // test body here
      dut.io.i_s1.poke(1.U)
      dut.io.i_s2.poke(5.U)
      dut.clock.step(20)
      dut.io.o_res.expect(5.U)
    }
  }
}