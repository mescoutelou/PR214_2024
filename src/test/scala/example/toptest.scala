package prj.example

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import _root_.circt.stage.{ChiselStage}



class toptest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "GPR"
  // test class body here
  "GPR test" should "pass" in {
    // test case body here
    test(new top).withAnnotations (Seq( /*VerilatorBackendAnnotation,*/ WriteVcdAnnotation )){ dut =>
        // test body here
        dut.clock.step(10)
        dut.io.i_instr.poke("b0000000_01101_01100_000_00101_0110011".U)
        dut.clock.step(10)
    }
  }
}