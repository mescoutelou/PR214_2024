package prj.example

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class gprtest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "GPR"
  // test class body here
  "GPR test" should "pass" in {
    // test case body here
    test(new GPR).withAnnotations (Seq( /*VerilatorBackendAnnotation,*/ WriteVcdAnnotation )){ dut =>
        // test body here
        dut.io.i_data.poke("hff000005".U(32.W))
        dut.io.i_write.poke(false.B)
        dut.io.i_sel_reg(4.U(5.W))
        dut.io.i_read_reg1(0.U(5.W))
        dut.io.i_read_reg2(1.U(5.W))

        dut.clock.step(5)

        dut.io.i_write.poke(true.B)
        
        dut.clock.step(5)
        dut.io.i_write.poke(false.B)
        dut.io.i_read_reg1(4.U(5.W))

        dut.clock.step(5)
        dut.io.i_data.poke("h00003A00".U(32.W))
        dut.io.i_sel_reg(5.U(5.W))
        dut.clock.step(5)
        dut.io.i_read_reg2(5.U(5.W))
        

    }
  }
}