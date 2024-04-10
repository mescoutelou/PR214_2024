/*
 * File: app-br-now.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:33:51 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "../../../common/macro.h"
#include "../../../common/macro-br.h"


// ******************************
//            INIT
// ******************************
TEST_INIT(4)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //         R INSTRUCTION
  // ------------------------------
  //                  testnum,  instr_br, instr_ri, nnop, rs1,  v1,   rs2,  v2,   imm,    rd
  TEST_BR_NEXT_R_IMM( 0,        beq,      addi,     4,    x5,   0x20, x6,   0x20, 0x10,   x7)
  TEST_BR_NEXT_R_IMM( 1,        beq,      xori,     4,    x5,   0x30, x6,   0x30, 0x11,   x7)
  TEST_BR_NEXT_R_IMM( 2,        bne,      andi,     4,    x5,   0x30, x6,   0x20, 0x12,   x7)

  ## ------------------------------
  ##        RR INSTRUCTION
  ## ------------------------------
  //              testnum,  instr_br, instr_rr, nnop, rs1,  v1,   rs2,  v2,   rd
  TEST_BR_NEXT_RR(3,        beq,      add,      0,    x5,   0x10, x6,   0x10, x7)
  ## ------------------------------
  ##        LOAD INSTRUCTION
  ## ------------------------------
  //              testnum,  instr_br, instr_st, instr_ld, tbase,  nnop, rs1,  v1,   rs2,  v2,   rd
  //TEST_BR_NEXT_LD()

  ## ------------------------------
  ##        STORE INSTRUCTION
  ## ------------------------------
  //              testnum,  instr_br, instr_st, instr_ld, tbase,  nnop, rs1,  v1,   rs2,  v2,   rd
  //TEST_BR_NEXT_ST()
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END

// ******************************
//             DATA
// ******************************
TEST_RODATA
TEST_DATA
