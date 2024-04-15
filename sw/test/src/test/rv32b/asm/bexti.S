/*
 * File: bexti.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-05 10:25:18 am
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
  TEST_R_IMM( 0,        bexti,  0,      x5,   0x0000000000000000,   0,    x7,   0)

  TEST_R_IMM( 1,        bexti,  0,      x5,   0x0000000000000001,   0,    x7,   1)
  TEST_R_IMM( 2,        bexti,  0,      x5,   0x000000000000ffff,   1,    x7,   1)
  TEST_R_IMM( 3,        bexti,  0,      x5,   0x000000000000ffff,   15,   x7,   1)
  TEST_R_IMM( 4,        bexti,  0,      x5,   0x0000000000000000,   16,   x7,   0)
  TEST_R_IMM( 5,        bexti,  0,      x5,   0x0000000000000000,   31,   x7,   0)

  TEST_R_IMM( 6,        bexti,  0,      x5,   0xffffffffffffffff,   0,    x7,   1)
  TEST_R_IMM( 7,        bexti,  0,      x5,   0xf0f0f0f0f0f0f0f0,   1,    x7,   0)
  TEST_R_IMM( 8,        bexti,  0,      x5,   0xf0f0f0f0f0f0f0f0,   15,   x7,   1)
  TEST_R_IMM( 9,        bexti,  0,      x5,   0xf0f0f0f0f0f0f0f0,   16,   x7,   0)
  TEST_R_IMM( 10,       bexti,  0,      x5,   0xf0f0f0f0f0f0f0f0,   31,   x7,   1)

  #if (XLEN == 64)
  TEST_R_IMM( 11,       bexti,  0,      x5,   0x0000000100000001,   32,   x7,   1)
  TEST_R_IMM( 12,       bexti,  0,      x10,  0x0000000100000001,   50,   x12,  0)
  TEST_R_IMM( 13,       bexti,  0,      x13,  0x0000000100000001,   63,   x15,  0)
  TEST_R_IMM( 14,       bexti,  0,      x12,  0xffffffffffffffff,   32,   x11,  1)
  TEST_R_IMM( 15,       bexti,  0,      x17,  0xffffffffffffffff,   63,   x13,  1)
  #else 
  TEST_R_IMM( 11,       bexti,  0,      x5,   0x00000001,           7,    x7,   0)
  TEST_R_IMM( 12,       bexti,  0,      x10,  0x00000001,           1,    x12,  0)
  TEST_R_IMM( 13,       bexti,  0,      x13,  0x00000001,           16,   x15,  0)
  TEST_R_IMM( 14,       bexti,  0,      x12,  0xffffffff,           8,    x11,  1)
  TEST_R_IMM( 15,       bexti,  0,      x17,  0xffffffff,           24,   x13,  1)
  #endif

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 16,       bexti,  0,      x7,   0x22,   3,      x7,   0)
  TEST_R_IMM( 17,       bexti,  0,      x7,   0x31,   1,      x7,   0)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 18,       bexti,  0,      x0,   0x20,   2,      x7,   0)
  TEST_R_IMM( 19,       bexti,  0,      x7,   0x30,   1,      x0,   0)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //              testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM_BYP( 20,       bexti,  0,      x5,   0x21,   0,      x10,  1)
  TEST_R_IMM_BYP( 21,       bexti,  1,      x5,   0x21,   1,      x10,  0)
  TEST_R_IMM_BYP( 22,       bexti,  2,      x5,   0x25,   2,      x10,  1)
  TEST_R_IMM_BYP( 23,       bexti,  4,      x5,   0x21,   3,      x10,  0)

  //              testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM(     24,       bexti,  1,      x5,   0xff33, 4,      x7,   1)
  TEST_R_IMM(     25,       bexti,  2,      x5,   0xff33, 8,      x7,   1)
  TEST_R_IMM(     26,       bexti,  4,      x5,   0xff33, 5,      x7,   1)
  TEST_R_IMM(     27,       bexti,  8,      x5,   0x0f33, 12,     x7,   0)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
