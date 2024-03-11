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
    val o_sel_operande = Output(Bool())
    val o_imm = Output(UInt(12.W))
    val o_rd = Output(UInt(5.W))
  })  

val w_decoder = ListLookup(io.i_instruct, TABLECODE.default, TABLECODE.table)

when(w_decoder(0) === 0.U){           // 0 = type R
  io.o_imm := 0.U(12.W)
} .elsewhen(w_decoder(0) === 1.U){    // 1 = type I
  io.o_imm := io.i_instruct(31,20)
} .elsewhen(w_decoder(0) === 2.U){    // 2 = type S
  io.o_imm := Cat(io.i_instruct(31,25),io.i_instruct(11,7))
} .elsewhen(w_decoder(0) === 3.U){    // 3 = type B
  io.o_imm :=Cat(io.i_instruct(31),io.i_instruct(7),io.i_instruct(30,25),io.i_instruct(11,8))
} otherwise{
  io.o_imm := 0.U(12.W)
}
io.o_rs1 := io.i_instruct(19, 15)
io.o_rs2 := io.i_instruct(24, 20)
io.o_rd := io.i_instruct(7, 11)



io.funct_sel := w_decoder(1)
switch(w_decoder(2)){
  is(0.U) {io.o_sel_operande := false.B}
  is(1.U) {io.o_sel_operande := true.B}
}



}

object OPE {
    def ADDI   = BitPat("b?????????????????000?????0010011".U)
    def XORI   = BitPat("b?????????????????100?????0010011".U)
    def ORI    = BitPat("b?????????????????110?????0010011".U)
    def ANDI   = BitPat("b?????????????????111?????0010011".U)
    def SLLI   = BitPat("b?????????????????001?????0010011".U)
    def SRLI   = BitPat("b?????????????????101?????0010011".U)
    def SRAI   = BitPat("b?1???????????????101?????0010011".U)
    def ADD    = BitPat("b?????????????????000?????0110011".U)
    def SUB    = BitPat("b?1???????????????000?????0110011".U)
    def XOR    = BitPat("b?????????????????100?????0110011".U)
    def OR     = BitPat("b?????????????????110?????0110011".U)
    def AND    = BitPat("b?????????????????111?????0110011".U)
    def SLL    = BitPat("b?????????????????001?????0110011".U)
    def SRL    = BitPat("b?????????????????101?????0110011".U)
    def SRA    = BitPat("b?1???????????????101?????0110011".U)
}


object TABLECODE{
    val default: List[UInt] = List[UInt]( 0.U, 0.U, 0.U)
    val table: Array[(BitPat, List[UInt])] = Array[(BitPat, List[UInt])] (
        OPE.ADDI          -> List(  1.U, 0.U, 0.U),
        OPE.XORI          -> List(  1.U, 2.U, 0.U),
        OPE.ORI           -> List(  1.U, 3.U, 0.U),
        OPE.ANDI          -> List(  1.U, 4.U, 0.U),
        OPE.SLLI          -> List(  0.U, 5.U, 0.U),
        OPE.SRLI          -> List(  0.U, 6.U, 0.U),
        OPE.SRAI          -> List(  0.U, 7.U, 0.U),
        OPE.ADD           -> List(  0.U, 0.U, 1.U),
        OPE.SUB           -> List(  0.U, 1.U, 1.U),
        OPE.XOR           -> List(  0.U, 2.U, 1.U),
        OPE.OR            -> List(  0.U, 3.U, 1.U),
        OPE.AND           -> List(  0.U, 4.U, 1.U),
        OPE.SLL           -> List(  0.U, 5.U, 1.U),
        OPE.SRL           -> List(  0.U, 6.U, 1.U),
        OPE.SRA           -> List(  0.U, 7.U, 1.U)
    )
}


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