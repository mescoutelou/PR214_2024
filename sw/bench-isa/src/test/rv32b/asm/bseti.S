/*
 * File: bseti.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-05 10:33:16 am
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
  TEST_R_IMM( 0,        bseti,  0,      x5,   0x0000000000000000,   0,    x7,   0x0000000000000001)

  TEST_R_IMM( 1,        bseti,  0,      x5,   0x0000000000000001,   0,    x7,   0x0000000000000001)
  TEST_R_IMM( 2,        bseti,  0,      x5,   0x0000000000000000,   1,    x7,   0x0000000000000002)
  TEST_R_IMM( 3,        bseti,  0,      x5,   0x0000000000000000,   15,   x7,   0x0000000000008000)
  TEST_R_IMM( 4,        bseti,  0,      x5,   0x0000000000000000,   16,   x7,   0x0000000000010000)
  TEST_R_IMM( 5,        bseti,  0,      x5,   0x0000000000000000,   31,   x7,   0x0000000080000000)

  TEST_R_IMM( 6,        bseti,  0,      x5,   0xffffffffffffffff,   0,    x7,   0xffffffffffffffff)
  TEST_R_IMM( 7,        bseti,  0,      x5,   0xf0f0f0f0f0f0f0f0,   1,    x7,   0xf0f0f0f0f0f0f0f2)
  TEST_R_IMM( 8,        bseti,  0,      x5,   0xf0f0f0f0f0f0f0f0,   15,   x7,   0xf0f0f0f0f0f0f0f0)
  TEST_R_IMM( 9,        bseti,  0,      x5,   0xf0f0f0f0f0f0f0f0,   16,   x7,   0xf0f0f0f0f0f1f0f0)
  TEST_R_IMM( 10,       bseti,  0,      x5,   0xf0f0f0f0f0f0f0f0,   31,   x7,   0xf0f0f0f0f0f0f0f0)

  #if (XLEN == 64)
  TEST_R_IMM( 11,       bseti,  0,      x5,   0x0000000000000001,   32,   x7,   0x0000000100000001)
  TEST_R_IMM( 12,       bseti,  0,      x10,  0x0000000000000001,   50,   x12,  0x0004000000000001)
  TEST_R_IMM( 13,       bseti,  0,      x13,  0x0000000000000001,   63,   x15,  0x1000000000000001)
  TEST_R_IMM( 14,       bseti,  0,      x12,  0xffffffffffffffff,   32,   x11,  0xffffffffffffffff)
  TEST_R_IMM( 15,       bseti,  0,      x17,  0xffffffffffffffff,   63,   x13,  0xffffffffffffffff)
  #else 
  TEST_R_IMM( 11,       bseti,  0,      x5,   0x00000001,           7,    x7,   0x00000081)
  TEST_R_IMM( 12,       bseti,  0,      x10,  0x00000001,           3,    x12,  0x00000009)
  TEST_R_IMM( 13,       bseti,  0,      x13,  0x00000001,           16,   x15,  0x00010001)
  TEST_R_IMM( 14,       bseti,  0,      x12,  0xffffffff,           8,    x11,  0xffffffff)
  TEST_R_IMM( 15,       bseti,  0,      x17,  0xffffffff,           24,   x13,  0xffffffff)
  #endif

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 16,       bseti,  0,      x7,   0x22,   3,      x7,   0x2a)
  TEST_R_IMM( 17,       bseti,  0,      x7,   0x30,   1,      x7,   0x32)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 18,       bseti,  0,      x0,   0x20,   2,      x7,   0x04)
  TEST_R_IMM( 19,       bseti,  0,      x7,   0x30,   1,      x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //              testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM_BYP( 20,       bseti,  0,      x5,   0x21,   0,      x10,  0x21)
  TEST_R_IMM_BYP( 21,       bseti,  1,      x5,   0x21,   1,      x10,  0x23)
  TEST_R_IMM_BYP( 22,       bseti,  2,      x5,   0x21,   2,      x10,  0x25)
  TEST_R_IMM_BYP( 23,       bseti,  4,      x5,   0x21,   3,      x10,  0x29)

  //              testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM(     24,       bseti,  1,      x5,   0x01,   4,      x7,   0x0011)
  TEST_R_IMM(     25,       bseti,  2,      x5,   0x01,   8,      x7,   0x0101)
  TEST_R_IMM(     26,       bseti,  4,      x5,   0x01,   5,      x7,   0x0021)
  TEST_R_IMM(     27,       bseti,  8,      x5,   0x03,   12,     x7,   0x1003)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
