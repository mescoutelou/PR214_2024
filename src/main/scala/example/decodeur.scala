package prj.example
import chisel3._
import chisel3.util._
import prj.common.gen._

class Decodeur extends Module {
  val io = IO(new Bundle {
    val i_instruct = Input(UInt(32.W)) 

    val funct_sel = Output(UInt(5.W))
    val o_rs1 = Output(UInt(5.W))
    val o_rs2 = Output(UInt(5.W))
    val o_sel_operande = Output(UInt(1.W))
    val o_imm = Output(UInt(12.W))
  })  

val w_decoder = ListLookup(io.i_instruct, TABLECODE.default, TABLECODE.table)

/*switch(w_decoder(0)){
  is(0.U){io.o_imm := 0.U(12.W)}
  is(1.U){io.o_imm := io.i_instruct(31,20)}
  is(2.U){io.o_imm := Cat(io.i_instruct(31,25),io.i_instruct(11,7))}
  is(3.U){io.o_imm := Cat(io.i_instruct(31),io.i_instruct(7),io.i_instruct(30,25),io.i_instruct(11,8))}
}
*/

when(w_decoder(0) === 0.U){
  io.o_imm := 0.U(12.W)
} .elsewhen(w_decoder(0) === 1.U){
  io.o_imm := io.i_instruct(31,20)
} .elsewhen(w_decoder(0) === 2.U){
  io.o_imm := Cat(io.i_instruct(31,25),io.i_instruct(11,7))
} .elsewhen(w_decoder(0) === 3.U){
  io.o_imm :=Cat(io.i_instruct(31),io.i_instruct(7),io.i_instruct(30,25),io.i_instruct(11,8))
} otherwise{
  io.o_imm = 0.U(12.W)
}
io.o_rs1 := io.i_instruct(19, 15)
io.o_rs2 := io.i_instruct(24, 20)


/*
val imm_I = io.i_instruct(31,20)
val imm_S = Cat(io.i_instruct(31,25),io.i_instruct(11,7))
val imm_B = Cat(io.i_instruct(31),io.i_instruct(7),io.i_instruct(30,25),io.i_instruct(11,8))
*/

io.funct_sel := w_decoder(1)
io.o_sel_operande := w_decoder(2)

// io.funct_sel    := w_decoder(0)
// io.o_rs1          := w_decoder(1)
// io.o_rs2      := w_decoder(2)
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


object TABLECODE{
    val default: List[UInt] = List[UInt]( 0.U, 0.U, 0.U)
    val table: Array[(BitPat, List[UInt])] = Array[(BitPat, List[UInt])] (
        OPE.ADDI          -> List(  0.U, 0.U, 0.U),
        OPE.XORI          -> List(  0.U, 2.U, 0.U),
        OPE.ORI           -> List(  0.U, 3.U, 0.U),
        OPE.ANDI          -> List(  0.U, 4.U, 0.U),
        OPE.SLLI          -> List(  1.U, 5.U, 0.U),
        OPE.SRLI          -> List(  1.U, 6.U, 0.U),
        OPE.SRAI          -> List(  1.U, 7.U, 0.U),
        OPE.ADD           -> List(  1.U, 0.U, 1.U),
        OPE.SUB           -> List(  1.U, 1.U, 1.U),
        OPE.XOR           -> List(  1.U, 2.U, 1.U),
        OPE.OR            -> List(  1.U, 3.U, 1.U),
        OPE.AND           -> List(  1.U, 4.U, 1.U),
        OPE.SLL           -> List(  1.U, 5.U, 1.U),
        OPE.SRL           -> List(  1.U, 6.U, 1.U),
        OPE.SRA           -> List(  1.U, 7.U, 1.U)
    )
}

// object TABLECODE {
//   //                                  sel_op    rs1                             rs2/imm                        sel_operande
//   //                                     |       |                                 |                                 | 
//   val default: List[UInt] = List[UInt]( 0.U,  0.U,                                0.U,                              0.U)
//   val table: Array[(BitPat, List[UInt])] = Array[(BitPat, List[UInt])] (
//     OPE.ADDI          -> List(  0.U,  io.i_instruct(20, 16),     io.i_instruct(31, 20),   0.U),
//     OPE.XORI          -> List(  2.U,  io.i_instruct(20, 16),     io.i_instruct(31, 20),   0.U),
//     OPE.ORI           -> List(  3.U,  io.i_instruct(20, 16),     io.i_instruct(31, 20),   0.U),
//     OPE.ANDI          -> List(  4.U,  io.i_instruct(20, 16),     io.i_instruct(31, 20),   0.U),
//     OPE.SLLI          -> List(  5.U,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   0.U),
//     OPE.SRLI          -> List(  6.U,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   0.U),
//     OPE.SRAI          -> List(  7.U,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   0.U),
//     OPE.ADD           -> List(  0.U,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.U),
//     OPE.SUB           -> List(  1.U,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.U),
//     OPE.XOR           -> List(  2.U,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.U),
//     OPE.OR            -> List(  3.U,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.U),
//     OPE.AND           -> List(  4.U,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.U),
//     OPE.SLL           -> List(  5.U,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.U),
//     OPE.SRL           -> List(  6.U,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.U),
//     OPE.SRA           -> List(  7.U,  io.i_instruct(20, 16),     io.i_instruct(24, 20),   1.U)
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