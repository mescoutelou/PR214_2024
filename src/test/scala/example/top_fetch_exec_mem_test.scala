package prj.example
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import _root_.circt.stage.{ChiselStage}


class top_fetch_exec_mem_test extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "top_fetch_exec_mem"
  // test class body here
  "top_fetch_exec_mem test" should "pass" in {
    // test case body here
    test(new top_fetch_exec_mem).withAnnotations (Seq( /*VerilatorBackendAnnotation,*/ WriteVcdAnnotation )){ dut =>
      // test body here
      dut.clock.step(10)


    }
  }
}