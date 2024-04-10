/*
 * File: addi.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:33:36 am
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
  //           ARITHMETIC
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,                   imm,    rd,   vr
  TEST_R_IMM( 0,        addi,   0,      x5,   0x0000000000000000,   0x000,  x7,   0x0000000000000000)
  TEST_R_IMM( 1,        addi,   0,      x5,   0x0000000000000001,   0x001,  x7,   0x0000000000000002)
  TEST_R_IMM( 2,        addi,   0,      x5,   0x0000000000000008,   0x008,  x7,   0x0000000000000010)

  TEST_R_IMM( 3,        addi,   0,      x5,   0xffffffffffffffff,   0x000,  x7,   0xffffffffffffffff)
  TEST_R_IMM( 4,        addi,   0,      x5,   0xffffffff80000000,   0x7ff,  x7,   0xffffffff800007ff)
  TEST_R_IMM( 5,        addi,   0,      x5,   0x0000000000000000,   0xfff,  x7,   0xffffffffffffffff)

  TEST_R_IMM( 6,        addi,   0,      x5,   0x0000000000000002,   0xfff,  x7,   0x0000000000000001)
  TEST_R_IMM( 7,        addi,   0,      x5,   0xffffffffffffffff,   0xfff,  x7,   0xfffffffffffffffe)
  TEST_R_IMM( 8,        addi,   0,      x5,   0x000000000000ffff,   0x001,  x7,   0x0000000000010000)

  TEST_R_IMM( 9,        addi,   0,      x5,   0xffffffff00000000,   0xfff,  x7,   0xfffffffeffffffff)
  TEST_R_IMM( 10,       addi,   0,      x5,   0x00000000ffffffff,   0x001,  x7,   0x0000000100000000)
  TEST_R_IMM( 11,       addi,   0,      x5,   0xf0f0f0f0f0f0f0f0,   0xf0f,  x7,   0xf0f0f0f0f0f0efff)

  TEST_R_IMM( 12,       addi,   0,      x10,  0x0000000000008fff,   0xfff,  x12,  0x0000000000008ffe)
  TEST_R_IMM( 13,       addi,   0,      x13,  0x0000000000000001,   0x001,  x15,  0x0000000000000002)
  TEST_R_IMM( 14,       addi,   0,      x12,  0xffff0000ffff0002,   0xf0f,  x11,  0xffff0000fffeff11)
  TEST_R_IMM( 15,       addi,   0,      x17,  0x0000000010000000,   0xf0f,  x13,  0x000000000fffff0f)  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 16,       addi,   0,      x7,   0x20,   0x011,  x7,   0x31)
  TEST_R_IMM( 17,       addi,   0,      x7,   0x30,   0x030,  x7,   0x60)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 18,       addi,   0,      x0,   0x20,   0x021,  x7,   0x21)
  TEST_R_IMM( 19,       addi,   0,      x7,   0x20,   0x031,  x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //              testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM_BYP( 20,       addi,   0,      x5,   0x30,   0x010,  x10,  0x40)
  TEST_R_IMM_BYP( 21,       addi,   1,      x5,   0x30,   0x011,  x10,  0x41)
  TEST_R_IMM_BYP( 22,       addi,   2,      x5,   0x30,   0x012,  x10,  0x42)
  TEST_R_IMM_BYP( 23,       addi,   4,      x5,   0x30,   0x014,  x10,  0x44)

  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 24,       addi,   1,      x5,   0x20,   0x021,  x7,   0x41)
  TEST_R_IMM( 25,       addi,   2,      x5,   0x21,   0x021,  x7,   0x42)
  TEST_R_IMM( 26,       addi,   4,      x5,   0x24,   0x022,  x7,   0x46)
  TEST_R_IMM( 27,       addi,   8,      x5,   0x28,   0x030,  x7,   0x58)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
