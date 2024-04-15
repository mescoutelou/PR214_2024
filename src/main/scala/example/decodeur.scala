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

    // Selectionne immédiat ou registre
    val o_sel_operande = Output(Bool())
    val o_imm = Output(UInt(12.W))
    val o_rd = Output(UInt(5.W))

    val o_GPRwrite = Output(Bool())
    val o_wEnable = Output(Bool())
    val o_rEnable = Output(Bool())


    // Vérification de la validité de l'instruction
    //val o_isValid = Output(Bool())Gains
  })  

  val w_decoder = ListLookup(io.i_instruct, TABLECODE.default, TABLECODE.table)
  val isValid = RegInit(0.B)



  // Vérification opcode
  when(
    io.i_instruct(6,0) === "b0110111".U ||
    io.i_instruct(6,0) === "b0010111".U ||
    io.i_instruct(6,0) === "b1101111".U ||
    io.i_instruct(6,0) === "b1100111".U ||
    io.i_instruct(6,0) === "b1100011".U ||
    io.i_instruct(6,0) === "b0000011".U ||
    io.i_instruct(6,0) === "b0100011".U ||
    io.i_instruct(6,0) === "b0010011".U ||
    io.i_instruct(6,0) === "b0110011".U ||
    io.i_instruct(6,0) === "b0001111".U ||
    io.i_instruct(6,0) === "b1110011".U
  ){
    isValid := true.B
  } .otherwise{
    isValid := false.B
  }


when (isValid === true.B){
                when(w_decoder(0) === 0.U){           // 0 = type R
                  io.o_imm := 0.U(12.W)
                } .elsewhen(w_decoder(0) === 1.U){    // 1 = type I
                  io.o_imm := io.i_instruct(31,20)
                } .elsewhen(w_decoder(0) === 2.U){    // 2 = type S
                  io.o_imm := Cat(io.i_instruct(31,25),io.i_instruct(11,7))
                } .elsewhen(w_decoder(0) === 3.U){    // 3 = type B
                  io.o_imm :=Cat(io.i_instruct(31),io.i_instruct(7),io.i_instruct(30,25),io.i_instruct(11,8))
                } .elsewhen(w_decoder(0) === 4.U){    // 4 = type U
                  io.o_imm := Cat(io.i_instruct(31, 12))
                }.elsewhen(w_decoder(0) === 5.U){     // 5 = type J
                  io.o_imm := Cat(io.i_instruct(31), io.i_instruct(19, 12), io.i_instruct(20), io.i_instruct(30, 21))
                } otherwise{
                  io.o_imm := 0.U(12.W)
                }
                io.o_rs1 := io.i_instruct(19, 15)
                io.o_rs2 := io.i_instruct(24, 20)
                io.o_rd := io.i_instruct(11, 7)

                io.funct_sel := w_decoder(1)
                io.o_sel_operande := DontCare

                switch(w_decoder(2)){
                  is(0.U) {io.o_sel_operande := false.B}
                  is(1.U) {io.o_sel_operande := true.B}
                }

                //Signaux de contrôle selon op code

                // Memory Write Enable (wEnable)
                //OP code de SW, SH, SB
                when(io.i_instruct(6,0) === "b0100011".U){
                  io.o_wEnable := true.B
                }.otherwise{io.o_wEnable := false.B}


                // Memory Read Enable (rEnable)
                //OP code de LW, LH, LB
                when(io.i_instruct(6,0) === "b0000011".U){
                io.o_rEnable := true.B
                }.otherwise{io.o_rEnable := false.B}


                // Activation écriture GPR
                // Cas où pas besoin d'écrire
                when( io.i_instruct(6,0) === "b1100011".U ||     //Branchement
                      io.i_instruct(6,0) === "b0000011".U){      //SW, SH, SB
                        io.o_GPRwrite := false.B
                      } .otherwise(io.o_GPRwrite := true.B)   
    }
  .otherwise{io.funct_sel := "b00000".U
              io.o_rs1 := "b00000".U
              io.o_rs2 := DontCare
              io.o_sel_operande := true.B
              io.o_imm := "b000000000000".U
              io.o_rd := "b00000".U


              io.o_GPRwrite := false.B
              io.o_wEnable := false.B
              io.o_rEnable := false.B

  }
}




object OPE {
    def ADDI   = BitPat("b?????????????????000?????0010011")
    def XORI   = BitPat("b?????????????????100?????0010011")
    def ORI    = BitPat("b?????????????????110?????0010011")
    def ANDI   = BitPat("b?????????????????111?????0010011")
    def SLLI   = BitPat("b?????????????????001?????0010011")
    def SRLI   = BitPat("b?????????????????101?????0010011")
    def SRAI   = BitPat("b?1???????????????101?????0010011")
    def ADD    = BitPat("b?0???????????????000?????0110011")
    def SUB    = BitPat("b?1???????????????000?????0110011")
    def XOR    = BitPat("b?????????????????100?????0110011")
    def OR     = BitPat("b?????????????????110?????0110011")
    def AND    = BitPat("b?????????????????111?????0110011")
    def SLL    = BitPat("b?????????????????001?????0110011")
    def SRL    = BitPat("b?0???????????????101?????0110011")
    def SRA    = BitPat("b?1???????????????101?????0110011")
    def LUI    = BitPat("b?????????????????????????0110111")
    def AUIPC  = BitPat("b?????????????????????????0010111")
    def JAL    = BitPat("b?????????????????????????1101111")
    def JALR   = BitPat("b?????????????????000?????1100111")
    def BEQ    = BitPat("b?????????????????000?????1100011")
    def BNE    = BitPat("b?????????????????001?????1100011")
    def BLT    = BitPat("b?????????????????100?????1100011")
    def BGE    = BitPat("b?????????????????101?????1100011")
    def BLTU   = BitPat("b?????????????????110?????1100011")
    def BGEU   = BitPat("b?????????????????111?????1100011")
    def LB     = BitPat("b?????????????????000?????0000011")
    def LH     = BitPat("b?????????????????001?????0000011")
    def LW     = BitPat("b?????????????????010?????0000011")
    def LBU    = BitPat("b?????????????????100?????0000011")
    def LHU    = BitPat("b?????????????????101?????0000011")
    def SB     = BitPat("b?????????????????000?????0100011")
    def SH     = BitPat("b?????????????????001?????0100011")
    def SW     = BitPat("b?????????????????010?????0100011")
    def SLTI   = BitPat("b?????????????????010?????0010011")
    def SLTIU  = BitPat("b?????????????????011?????0010011")
    def SLT    = BitPat("b?????????????????010?????0110011")
    def SLTU   = BitPat("b?????????????????011?????0110011")

}


object TABLECODE{                        //type(RISBUJ)     //opération      // avec/sans immédiat
    val default: List[UInt] = List[UInt]( 0.U,             0.U,             0.U)
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
        OPE.SRA           -> List(  0.U, 7.U, 1.U),
        OPE.LUI           -> List(  4.U, 0.U, 0.U),
        OPE.AUIPC         -> List(  4.U, 0.U, 0.U),
        OPE.JAL           -> List(  5.U, 0.U, 0.U),
        OPE.JALR          -> List(  1.U, 0.U, 0.U),
        OPE.BEQ           -> List(  3.U, 0.U, 0.U),
        OPE.BNE           -> List(  3.U, 0.U, 0.U),
        OPE.BLT           -> List(  3.U, 0.U, 0.U),
        OPE.BGE           -> List(  3.U, 0.U, 0.U),
        OPE.BLTU          -> List(  3.U, 0.U, 0.U),
        OPE.BGEU          -> List(  3.U, 0.U, 0.U),
        OPE.LB            -> List(  1.U, 0.U, 0.U),
        OPE.LH            -> List(  1.U, 0.U, 0.U),
        OPE.LW            -> List(  1.U, 0.U, 0.U),
        OPE.LBU           -> List(  1.U, 0.U, 0.U),
        OPE.LHU           -> List(  1.U, 0.U, 0.U),
        OPE.SB            -> List(  2.U, 0.U, 0.U),
        OPE.SH            -> List(  2.U, 0.U, 0.U),
        OPE.SW            -> List(  2.U, 0.U, 0.U),
        OPE.SLTI          -> List(  1.U, 0.U, 0.U),
        OPE.SLTIU         -> List(  1.U, 0.U, 0.U),
        OPE.SLT           -> List(  0.U, 0.U, 1.U),
        OPE.SLTU          -> List(  0.U, 0.U, 1.U),
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