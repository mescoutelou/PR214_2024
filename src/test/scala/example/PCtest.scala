package prj.example

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec


class PCtest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "Decodeur"
  // test class body here
  "PC test" should "pass" in {
    // test case body here
    test(new PC).withAnnotations (Seq( /*VerilatorBackendAnnotation,*/ WriteVcdAnnotation )){ dut =>
      // test body here
      dut.io.i_donnee.poke("b00000000000000000000000010001000".U) 
      dut.io.i_enable_mux.poke("b0".U)
      dut.io.i_enable_PC.poke("b0".U) 
      dut.clock.step(4)
      dut.io.i_enable_mux.poke("b1".U)
      dut.clock.step(4)
      dut.io.i_enable_mux.poke("b0".U)
      dut.io.i_enable_PC.poke("b1".U)
      dut.clock.step(4)
      dut.io.i_enable_mux.poke("b1".U)
      dut.clock.step(4)
    }
  }
}