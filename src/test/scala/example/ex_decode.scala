package prj.example

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
      dut.io.i_instruct.poke("00000001101100001000001110110011")
      dut.clock.step(10)
    }
  }