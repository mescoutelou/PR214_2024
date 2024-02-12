package prj.example
import chisel3._
import chisel3.util._

class Decodeur (nBit: Int) extends Module {
  val io = IO(new Bundle {
    val i_instruct = Input(UInt(32.W))  
    val o_select_op = Output(UInt(5.W))
    val o_rs1 = Output(UInt(5.W))
    val o_rs2 = Output(UInt(5.W))
    val o_imm = Output(UInt(N.W))
    val o_funct3 = Output(UInt(3.W))
    val o_opcode = Output(UInt(7.W))
  })  
  N.W
  val N = 12
  val opcode = io.i_instruct(6, 0)
  io.o_opcode := opcode
  val funct3 = "000"
  switch(opcode){
    is(~("0110111"|"0010111"|"1101111")) {io.o_funct3 := io.i_instruct(15, 13)}
    is(~("0110111"|"0010111"|"1101111"|"1110011")){io.o_rs1 := io.i_instruct(20, 16)}
    is(~("0110111"|"0010111"|"1101111"|"0000011"|"0010011"|"0001111"|"1110011")){io.o_rs2 := io.i_instruct(25, 21)}
    is(~("0010011"|"0110011"|"0001111"|"1110011")){io.o_imm := io.i_instruct(31, 20)}
    is("0110111"|"0010111"){N = 20; io.o_imm := io.i_instruct(31, 12)}
    is("1101111"){N = 20; io.o_imm(20, 11) := io.i_instruct(31) ## io.i_instruct(19, 12) ## io.i_instruct(20)}
    is("1100011"){io.o_imm := io.i_instruct(31) ## io.i_instruct(7) ## io.i_instruct(30, 25) ## io.i_instruct(11, 8)}
    is("0100011"){io.o_imm(4, 0) := io.i_instruct(11, 7)}  
    is("0010011"){N = 5; io.o_imm := io.i_instruct(24, 20); switch(funct3){
      is("000"){io.o_select_op := funct3}
      is("100"){io.o_select_op := 2}
      is("110"){io.o_select_op := 3}
      is("111"){io.o_select_op := 4}
      is("001"){io.o_select_op := 5}
      is("101"){io.o_select_op := 6 + io.i_instruct(30)}
      }
    }
    is("0110011"){switch(funct3){
      is("000"){io.o_select_op := funct3 + io.i_instruct(30)}
      is("100"){io.o_select_op := 2}
      is("110"){io.o_select_op := 3}
      is("111"){io.o_select_op := 4}
      is("001"){io.o_select_op := 5}
      is("101"){io.o_select_op := 6 + io.i_instruct(30)}
      }
    }
  }
}