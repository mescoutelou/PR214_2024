package prj.example

import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

class top_endtest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "top_end"
  // test class body here
  "top_end test" should "pass" in {
    // test case body here
    test(new top_end).withAnnotations (Seq( /*VerilatorBackendAnnotation,*/ WriteVcdAnnotation )){ dut =>
      // test body here
      dut.io.i_mem.poke("b0000000_01000_00001_000_00001_1111111".U) 
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01000_00001_000_00001_1111111".U) 
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2dut.io.i_mem.poke("b0000000_01000_00001_000_00001_1111111".U) 
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2dut.io.i_mem.poke("b0000000_01000_00001_000_00001_1111111".U) 
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2dut.io.i_mem.poke("b0000000_01000_00001_000_00001_1111111".U) 
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2dut.io.i_mem.poke("b0000000_01000_00001_000_00001_1111111".U) 
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2dut.io.i_mem.poke("b0000000_01000_00001_000_00001_1111111".U) 
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2dut.io.i_mem.poke("b0000000_01000_00001_000_00001_1111111".U) 
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2dut.io.i_mem.poke("b0000000_01000_00001_000_00001_1111111".U) 
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2dut.io.i_mem.poke("b0000000_01000_00001_000_00001_1111111".U) 
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2dut.io.i_mem.poke("b0000000_01000_00001_000_00001_1111111".U) 
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2dut.io.i_mem.poke("b0000000_01000_00001_000_00001_1111111".U) 
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2dut.io.i_mem.poke("b0000000_01000_00001_000_00001_1111111".U) 
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2dut.io.i_mem.poke("b0000000_01000_00001_000_00001_1111111".U) 
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2dut.io.i_mem.poke("b0000000_01000_00001_000_00001_1111111".U) 
      dut.clock.step(10)
      dut.io.i_mem.poke("b0000000_01010_00010_000_00010_0010011".U) //ADDI X2+10 VERS X2
    }
  }
}