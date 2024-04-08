package prj.core

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import _root_.circt.stage.{ChiselStage}



class Backtest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "Backtest"
  // test class body here
  "Back test" should "pass" in {
    // test case body here
    test(new Back).withAnnotations (Seq( /*VerilatorBackendAnnotation,*/ WriteVcdAnnotation )){ dut =>
        // test body here
        dut.io.i_instr.poke("b0000000_01000_00001_000_00001_0010011".U) //ADDI X1+8 VERS X1 
        dut.clock.step(1)
        dut.io.i_instr.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2
        dut.clock.step(1)
        dut.io.i_instr.poke("b0000000_00001_00001_000_00011_0110011".U) //ADD X1+X1 VERS X3
        dut.clock.step(1)
        dut.io.i_instr.poke("b0100000_00010_00001_000_00100_0110011".U) //SUB X1-X2 VERS X4
        dut.clock.step(1)
        dut.io.i_instr.poke("b0100000_00001_00100_101_00101_0110011".U) //SRA X4 >> X1 VERS X5
        dut.clock.step(1)
        dut.io.i_instr.poke("b0000000_00001_00100_101_00110_0110011".U) //SRL X4 >> X1 VERS X6
        dut.clock.step(8)
    }
  }
}