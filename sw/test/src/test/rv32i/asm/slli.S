/*
 * File: slli.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:35:51 am
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
  TEST_R_IMM( 0,        slli,   0,      x5,   0x0000000000000000,   0,    x7,   0x0000000000000000)

  TEST_R_IMM( 1,        slli,   0,      x5,   0x0000000000000001,   0,    x7,   0x0000000000000001)
  TEST_R_IMM( 2,        slli,   0,      x5,   0x0000000000000001,   1,    x7,   0x0000000000000002)
  TEST_R_IMM( 3,        slli,   0,      x5,   0x0000000000000001,   15,   x7,   0x0000000000008000)
  TEST_R_IMM( 4,        slli,   0,      x5,   0x0000000000000001,   16,   x7,   0x0000000000010000)
  TEST_R_IMM( 5,        slli,   0,      x5,   0x0000000000000001,   31,   x7,   0x0000000080000000)

  TEST_R_IMM( 6,        slli,   0,      x5,   0xffffffffffffffff,   0,    x7,   0xffffffffffffffff)
  TEST_R_IMM( 7,        slli,   0,      x5,   0xffffffffffffffff,   1,    x7,   0xfffffffffffffffe)
  TEST_R_IMM( 8,        slli,   0,      x5,   0xffffffffffffffff,   15,   x7,   0xffffffffffff8000)
  TEST_R_IMM( 9,        slli,   0,      x5,   0xffffffffffffffff,   16,   x7,   0xffffffffffff0000)
  TEST_R_IMM( 10,       slli,   0,      x5,   0xffffffffffffffff,   31,   x7,   0xffffffff80000000)

  #if (XLEN == 64)
  TEST_R_IMM( 11,       slli,   0,      x5,   0x0000000000000001,   32,   x7,   0x0000000100000000)
  TEST_R_IMM( 12,       slli,   0,      x10,  0x0000000000000001,   50,   x12,  0x0004000000000000)
  TEST_R_IMM( 13,       slli,   0,      x13,  0x0000000000000001,   63,   x15,  0x1000000000000000)
  TEST_R_IMM( 14,       slli,   0,      x12,  0xffffffffffffffff,   32,   x11,  0xffffffff00000000)
  TEST_R_IMM( 15,       slli,   0,      x17,  0xffffffffffffffff,   63,   x13,  0x8000000000000000)
  #else 
  TEST_R_IMM( 11,       slli,   0,      x5,   0x11111111,           7,    x7,   0x88888880)
  TEST_R_IMM( 12,       slli,   0,      x10,  0x11111111,           3,    x12,  0x88888888)
  TEST_R_IMM( 13,       slli,   0,      x13,  0x11111111,           16,   x15,  0x11110000)
  TEST_R_IMM( 14,       slli,   0,      x12,  0xffffffff,           8,    x11,  0xffffff00)
  TEST_R_IMM( 15,       slli,   0,      x17,  0xffffffff,           24,   x13,  0xff000000)
  #endif

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 16,       slli,   0,      x7,   0x22,   3,      x7,   0x0110)
  TEST_R_IMM( 17,       slli,   0,      x7,   0x30,   1,      x7,   0x0060)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 18,       slli,   0,      x0,   0x20,   2,      x7,   0x00)
  TEST_R_IMM( 19,       slli,   0,      x7,   0x30,   1,      x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //              testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM_BYP( 20,       slli,   0,      x5,   0x21,   0,      x10,  0x0021)
  TEST_R_IMM_BYP( 21,       slli,   1,      x5,   0x21,   1,      x10,  0x0042)
  TEST_R_IMM_BYP( 22,       slli,   2,      x5,   0x21,   2,      x10,  0x0084)
  TEST_R_IMM_BYP( 23,       slli,   4,      x5,   0x21,   4,      x10,  0x0210)

  //              testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM(     24,       slli,   1,      x5,   0x01,   4,      x7,   0x0010)
  TEST_R_IMM(     25,       slli,   2,      x5,   0x01,   8,      x7,   0x0100)
  TEST_R_IMM(     26,       slli,   4,      x5,   0x01,   5,      x7,   0x0020)
  TEST_R_IMM(     27,       slli,   8,      x5,   0x03,   12,     x7,   0x3000)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
