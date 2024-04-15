package prj.example
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class top_fetch_exec_mem_test extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "top_fetch_exec_mem"
  // test class body here
  "top_fetch_exec_mem test" should "pass" in {
    // test case body here
    test(new top_fetch_exec_mem).withAnnotations (Seq( /*VerilatorBackendAnnotation,*/ WriteVcdAnnotation )){ dut =>
      // test body here
      dut.io..poke("b0000000_00010_00001_000_00001_0010011".U)
    }
  }
}