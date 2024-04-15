package prj.example

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import _root_.circt.stage.{ChiselStage}



class fetchtest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "fetchtest"
  // test class body here
  "fetch test" should "pass" in {
    // test case body here
    test(new fetch).withAnnotations (Seq( /*VerilatorBackendAnnotation,*/ WriteVcdAnnotation )){ dut =>
        // test body here
        dut.io.i_jumpAdr.poke("h0000_0000_1000_0000".U)
        dut.io.i_jumpEnable.poke(false.B)
        dut.clock.step(10)
        dut.io.i_jumpEnable.poke(true.B)
        dut.clock.step(2)
        dut.io.i_jumpEnable.poke(false.B)
        dut.io.i_jumpAdr.poke("h0000_0000_0000_0000".U)        
        dut.clock.step(5)
        dut.io.i_jumpEnable.poke(true.B)
        dut.clock.step(2)
        dut.io.i_jumpEnable.poke(false.B)
        dut.clock.step(10)

    }
  }
}