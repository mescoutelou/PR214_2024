package prj.example
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import chisel3.util.experimental.loadMemoryFromFileInline

class InitMemInline_test extends AnyFlatSpec with ChiselScalatestTester{
    behavior of "test_mem"
    "test_mem test" should "pass" in {
    test (new InitMemInline("doc_memoire/d_mem.txt")) { c=>
            c.io.i_Adr.poke(1.U)
            c.clock.step(1)
            c.io.o_data.expect(0xA.U)
        }
  }
}