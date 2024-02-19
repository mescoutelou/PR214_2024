package prj.example
import chisel3._
import chisel3.util._
import prj.common.gen._

class Decodeur extends Module {
  val io = IO(new Bundle {
    val i_instruct = Input(UInt(32.W))  
    val o_select_op = Output(UInt(5.W))
    val o_rs1 = Output(UInt(5.W))
    val o_rs2_imm = Output(UInt(12.W))
    val o_sel_operande = Output(UInt(1.W))
  })  

val w_decoder = ListLookup(io.i_instruct, TABLECODE2.default, TABLECODE2.table)

io.o_select_op := w_decoder(1)
io.o_sel_operande := w_decoder(2)

switch(w_decoder(0)){
  is("b000"){io.o_rs1 := io.i_instruct(19, 15); io.o_rs2_imm := io.i_instruct(24, 20)}
  is("b001"){io.o_rs1 := io.i_instruct(19, 15); io.o_rs2_imm := io.i_instruct(31, 20)}
  //is("b010"){}
  //is("b011"){}
  //is("b100"){}
  //is("b101"){}
}

// io.o_select_op    := w_decoder(0)
// io.o_rs1          := w_decoder(1)
// io.o_rs2_imm      := w_decoder(2)
// io.o_sel_operande := w_decoder(3)
}

object OPE {
    def ADDI   = BitPat("b?????????????????000?????0010011")
    def XORI   = BitPat("b?????????????????100?????0010011")
    def ORI    = BitPat("b?????????????????110?????0010011")
    def ANDI   = BitPat("b?????????????????111?????0010011")
    def SLLI   = BitPat("b?????????????????001?????0010011")
    def SRLI   = BitPat("b?????????????????101?????0010011")
    def SRAI   = BitPat("b?1???????????????101?????0010011")
    def ADD    = BitPat("b?????????????????000?????0110011")
    def SUB    = BitPat("b?1???????????????000?????0110011")
    def XOR    = BitPat("b?????????????????100?????0110011")
    def OR     = BitPat("b?????????????????110?????0110011")
    def AND    = BitPat("b?????????????????111?????0110011")
    def SLL    = BitPat("b?????????????????001?????0110011")
    def SRL    = BitPat("b?????????????????101?????0110011")
    def SRA    = BitPat("b?1???????????????101?????0110011")
}


object TABLECODE2{
    val default: List[UInt] = List[UInt]( 0.B, 0.B, 0.B)
    val table: Array[(BitPat, List[UInt])] = Array[(BitPat, List[UInt])] (
        OPE.ADDI          -> List(  0.B, 0.B, 0.B),
        OPE.XORI          -> List(  0.B, 2.B, 0.B),
        OPE.ORI           -> List(  0.B, 3.B, 0.B),
        OPE.ANDI          -> List(  0.B, 4.B, 0.B),
        OPE.SLLI          -> List(  1.B, 5.B, 0.B),
        OPE.SRLI          -> List(  1.B, 6.B, 0.B),
        OPE.SRAI          -> List(  1.B, 7.B, 0.B),
        OPE.ADD           -> List(  1.B, 0.B, 1.B),
        OPE.SUB           -> List(  1.B, 1.B, 1.B),
        OPE.XOR           -> List(  1.B, 2.B, 1.B),
        OPE.OR            -> List(  1.B, 3.B, 1.B),
        OPE.AND           -> List(  1.B, 4.B, 1.B),
        OPE.SLL           -> List(  1.B, 5.B, 1.B),
        OPE.SRL           -> List(  1.B, 6.B, 1.B),
        OPE.SRA           -> List(  1.B, 7.B, 1.B)
    )
}

// object TABLECODE {
//   //                                  sel_op    rs1                             rs2/imm                        sel_operande
//   //                                     |       |                                 |                                 | 
//   val default: List[UInt] = List[UInt]( 0.B,  0.B,                                0.B,                              0.B)
//   val table: Array[(BitPat, List[UInt])] = Array[(BitPat, List[UInt])] (
//     OPE.ADDI          -> List(  0.B,  io.i_instruct(20, 16),     io.i_instruct(31, 20),   0.B),
//     OPE.XORI          -> List(  2.B,  io.i_instruct(20, 16),     io.i_instruct(31, 20),   0.B),
//     OPE.ORI           -> List(  3.B,  io.i_instruct(20, 16),     io.i_instruct(31, 20),   0.B),
//     OPE.ANDI          -> List(  4.B,  io.i_instruct(20, 16),     io.i_instruct(31, 20),   0.B),
//     OPE.SLLI          -> List(  5.B,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   0.B),
//     OPE.SRLI          -> List(  6.B,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   0.B),
//     OPE.SRAI          -> List(  7.B,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   0.B),
//     OPE.ADD           -> List(  0.B,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.B),
//     OPE.SUB           -> List(  1.B,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.B),
//     OPE.XOR           -> List(  2.B,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.B),
//     OPE.OR            -> List(  3.B,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.B),
//     OPE.AND           -> List(  4.B,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.B),
//     OPE.SLL           -> List(  5.B,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.B),
//     OPE.SRL           -> List(  6.B,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.B),
//     OPE.SRA           -> List(  7.B,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.B)
//   )
// }

object Decodeur extends App {
  _root_.circt.stage.ChiselStage.emitSystemVerilog(
    new Decodeur,
    firtoolOpts = Array.concat(
      Array(
        "--disable-all-randomization",
        "--strip-debug-info",
        "--split-verilog"
      ),
      args
    )      
  )
}