package prj.core

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class ALUTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "ALU"
  // test class body here
  "ALU test" should "pass" in {
    // test case body here
    test(new ALU).withAnnotations (Seq( /*VerilatorBackendAnnotation,*/ WriteVcdAnnotation )){ dut =>
      // test body here
      dut.io.i_rs1.poke(499.U(32.W))
      dut.io.i_operande.poke(37.U(32.W))
      dut.io.funct_sel.poke(0.U(5.W))
      dut.clock.step(5)
      dut.io.funct_sel.poke(1.U(5.W))
      dut.clock.step(5)
      dut.io.funct_sel.poke(2.U(5.W))
      dut.clock.step(5)
      dut.io.funct_sel.poke(3.U(5.W))
      dut.clock.step(5)
      dut.io.funct_sel.poke(4.U(5.W))
      dut.clock.step(5)
      dut.io.funct_sel.poke(5.U(5.W))
      dut.clock.step(5)
      dut.io.funct_sel.poke(6.U(5.W))
      dut.clock.step(5)
      dut.io.funct_sel.poke(7.U(5.W))
      dut.clock.step(5)
    }
  }
}