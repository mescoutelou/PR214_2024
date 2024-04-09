package emmk.core

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class DecodeurTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "Decodeur"
  // test class body here
  "Decodeur test" should "pass" in {
    // test case body here
    test(new Decodeur).withAnnotations (Seq( /*VerilatorBackendAnnotation,*/ WriteVcdAnnotation )){ dut =>
      // test body here
      dut.io.i_instruct.poke("b00100101101100101100001110010011".U)
      dut.clock.step(10)
    }
  }
}