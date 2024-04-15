/*
 * File: srli.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:36:21 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "../../../common/macro.h"
#include "../../../common/macro-r.h"


// ******************************
//            INIT
// ******************************
TEST_INIT(28)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //             LOGIC
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,                   imm,  rd,   vr
  TEST_R_IMM( 0,        srli,   0,      x5,   0x0000000000000000,   0,    x7,   0x0000000000000000)

  TEST_R_IMM( 1,        srli,   0,      x5,   0x8000000080000000,   0,    x7,   0x8000000080000000)
  TEST_R_IMM( 2,        srli,   0,      x5,   0x8000000080000000,   1,    x7,   0x4000000040000000)
  TEST_R_IMM( 3,        srli,   0,      x5,   0x8000000080000000,   15,   x7,   0x0001000000010000)
  TEST_R_IMM( 4,        srli,   0,      x5,   0x8000000080000000,   16,   x7,   0x0000800000008000)
  TEST_R_IMM( 5,        srli,   0,      x5,   0x8000000080000000,   31,   x7,   0x0000000100000001)
  
  TEST_R_IMM( 6,        srli,   0,      x5,   0x4000000040000000,   0,    x7,   0x4000000040000000)
  TEST_R_IMM( 7,        srli,   0,      x5,   0x4000000040000000,   1,    x7,   0x2000000020000000)
  TEST_R_IMM( 8,        srli,   0,      x5,   0x4000000040000000,   15,   x7,   0x0000800000008000)
  TEST_R_IMM( 9,        srli,   0,      x5,   0x4000000040000000,   16,   x7,   0x0000400000004000)
  #if (XLEN == 64)
  TEST_R_IMM( 10,       srli,   0,      x5,   0x4000000040000000,   31,   x7,   0x0000000080000000)
  #else
  TEST_R_IMM( 10,       srli,   0,      x5,   0x40000000,           31,   x7,   0x00000000)
  #endif

  #if (XLEN == 64)
  TEST_R_IMM( 11,       srli,   0,      x5,   0x8000000000000000,   32,   x7,   0x0000000080000000)
  TEST_R_IMM( 12,       srli,   0,      x10,  0x8000000000000000,   50,   x12,  0x0000000000002000)
  TEST_R_IMM( 13,       srli,   0,      x13,  0x8000000000000000,   63,   x15,  0x0000000000000001)
  TEST_R_IMM( 14,       srli,   0,      x12,  0xffffffffffffffff,   32,   x11,  0x00000000ffffffff)
  TEST_R_IMM( 15,       srli,   0,      x17,  0xffffffffffffffff,   63,   x13,  0x0000000000000001)
  #else 
  TEST_R_IMM( 11,       srli,   0,      x5,   0x80000000,           7,    x7,   0x01000000)
  TEST_R_IMM( 12,       srli,   0,      x10,  0x80000000,           3,    x12,  0x10000000)
  TEST_R_IMM( 13,       srli,   0,      x13,  0x80000000,           16,   x15,  0x00008000)
  TEST_R_IMM( 14,       srli,   0,      x12,  0xffffffff,           8,    x11,  0x00ffffff)
  TEST_R_IMM( 15,       srli,   0,      x17,  0xffffffff,           24,   x13,  0x000000ff)
  #endif

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 16,       srli,   0,      x7,   0x20,   3,      x7,   0x04)
  TEST_R_IMM( 17,       srli,   0,      x7,   0x31,   2,      x7,   0x0c)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 18,       srli,   0,      x0,   0x20,   2,      x7,   0x00)
  TEST_R_IMM( 19,       srli,   0,      x7,   0x30,   1,      x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //              testnum,  instr,  nnop,   rs1,  v1,       imm,    rd,   vr
  TEST_R_IMM_BYP( 20,       srli,   0,      x5,   0x48,     0,      x10,  0x48)
  TEST_R_IMM_BYP( 21,       srli,   1,      x5,   0x48,     1,      x10,  0x24)
  TEST_R_IMM_BYP( 22,       srli,   2,      x5,   0x48,     2,      x10,  0x12)
  TEST_R_IMM_BYP( 23,       srli,   4,      x5,   0x48,     3,      x10,  0x09)

  //              testnum,  instr,  nnop,   rs1,  v1,       imm,    rd,   vr
  TEST_R_IMM(     24,       srli,   1,      x5,   0x3010,   4,      x7,   0x0301)
  TEST_R_IMM(     25,       srli,   2,      x5,   0x3010,   8,      x7,   0x0030)
  TEST_R_IMM(     26,       srli,   4,      x5,   0x3010,   12,     x7,   0x0003)
  TEST_R_IMM(     27,       srli,   8,      x5,   0x9010,   12,     x7,   0x0009)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
