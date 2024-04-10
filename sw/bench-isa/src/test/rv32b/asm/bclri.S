/*
 * File: bclri.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-05 10:31:05 am
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
  TEST_R_IMM( 0,        bclri,  0,      x5,   0x0000000000000000,   0,    x7,   0x0000000000000000)

  TEST_R_IMM( 1,        bclri,  0,      x5,   0x0000000000000001,   0,    x7,   0x0000000000000000)
  TEST_R_IMM( 2,        bclri,  0,      x5,   0x000000000000ffff,   1,    x7,   0x000000000000fffd)
  TEST_R_IMM( 3,        bclri,  0,      x5,   0x000000000000ffff,   15,   x7,   0x0000000000007fff)
  TEST_R_IMM( 4,        bclri,  0,      x5,   0x000000000000ffff,   16,   x7,   0x000000000000ffff)
  TEST_R_IMM( 5,        bclri,  0,      x5,   0x000000000000ffff,   31,   x7,   0x000000000000ffff)

  TEST_R_IMM( 6,        bclri,  0,      x5,   0xffffffffffffffff,   0,    x7,   0xfffffffffffffffe)
  TEST_R_IMM( 7,        bclri,  0,      x5,   0xf0f0f0f0f0f0f0f0,   1,    x7,   0xf0f0f0f0f0f0f0f0)
  TEST_R_IMM( 8,        bclri,  0,      x5,   0xf0f0f0f0f0f0f0f0,   15,   x7,   0xf0f0f0f0f0f070f0)
  TEST_R_IMM( 9,        bclri,  0,      x5,   0xf0f0f0f0f0f0f0f0,   16,   x7,   0xf0f0f0f0f0f0f0f0)
  TEST_R_IMM( 10,       bclri,  0,      x5,   0xf0f0f0f0f0f0f0f0,   31,   x7,   0xf0f0f0f070f0f0f0)

  #if (XLEN == 64)
  TEST_R_IMM( 11,       bclri,  0,      x5,   0x0000000100000001,   32,   x7,   0x0000000000000001)
  TEST_R_IMM( 12,       bclri,  0,      x10,  0x0000000100000001,   50,   x12,  0x0000000100000001)
  TEST_R_IMM( 13,       bclri,  0,      x13,  0x0000000100000001,   63,   x15,  0x0000000100000001)
  TEST_R_IMM( 14,       bclri,  0,      x12,  0xffffffffffffffff,   32,   x11,  0xfffffffeffffffff)
  TEST_R_IMM( 15,       bclri,  0,      x17,  0xffffffffffffffff,   63,   x13,  0x7fffffffffffffff)
  #else 
  TEST_R_IMM( 11,       bclri,  0,      x5,   0x00000001,           7,    x7,   0x00000001)
  TEST_R_IMM( 12,       bclri,  0,      x10,  0x00000001,           3,    x12,  0x00000001)
  TEST_R_IMM( 13,       bclri,  0,      x13,  0x00000001,           16,   x15,  0x00000001)
  TEST_R_IMM( 14,       bclri,  0,      x12,  0xffffffff,           8,    x11,  0xfffffeff)
  TEST_R_IMM( 15,       bclri,  0,      x17,  0xffffffff,           24,   x13,  0xfeffffff)
  #endif

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 16,       bclri,  0,      x7,   0x22,   3,      x7,   0x22)
  TEST_R_IMM( 17,       bclri,  0,      x7,   0x31,   1,      x7,   0x31)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 18,       bclri,  0,      x0,   0x20,   2,      x7,   0x00)
  TEST_R_IMM( 19,       bclri,  0,      x7,   0x30,   1,      x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //              testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM_BYP( 20,       bclri,  0,      x5,   0x21,   0,      x10,  0x20)
  TEST_R_IMM_BYP( 21,       bclri,  1,      x5,   0x21,   1,      x10,  0x21)
  TEST_R_IMM_BYP( 22,       bclri,  2,      x5,   0x25,   2,      x10,  0x21)
  TEST_R_IMM_BYP( 23,       bclri,  4,      x5,   0x21,   3,      x10,  0x21)

  //              testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM(     24,       bclri,  1,      x5,   0xff33, 4,      x7,   0xff23)
  TEST_R_IMM(     25,       bclri,  2,      x5,   0xff33, 8,      x7,   0xfe33)
  TEST_R_IMM(     26,       bclri,  4,      x5,   0xff33, 5,      x7,   0xff13)
  TEST_R_IMM(     27,       bclri,  8,      x5,   0xff33, 12,     x7,   0xef33)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
