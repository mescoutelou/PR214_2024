/*
 * File: sltiu.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:36:03 am
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
  //            LOGIC
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,                   imm,    rd,   vr
  TEST_R_IMM( 0,        sltiu,  0,      x5,   0x0000000000000000,   0x000,  x7,   0)
  TEST_R_IMM( 1,        sltiu,  0,      x5,   0x0000000000000001,   0x002,  x7,   1)
  TEST_R_IMM( 2,        sltiu,  0,      x5,   0x0000000000000009,   0x008,  x7,   0)

  TEST_R_IMM( 3,        sltiu,  0,      x5,   0xffffffffffffffff,   0x000,  x7,   0)
  TEST_R_IMM( 4,        sltiu,  0,      x5,   0xffffffff80000000,   0x7ff,  x7,   0)
  TEST_R_IMM( 5,        sltiu,  0,      x5,   0x0000000000000000,   0xfff,  x7,   1)

  TEST_R_IMM( 6,        sltiu,  0,      x5,   0x0000000000000002,   0xfff,  x7,   1)
  TEST_R_IMM( 7,        sltiu,  0,      x5,   0xffffffffffffffff,   0xfff,  x7,   0)
  TEST_R_IMM( 8,        sltiu,  0,      x5,   0x000000000000ffff,   0x001,  x7,   0)

  TEST_R_IMM( 9,        sltiu,  0,      x5,   0xffff0000ffff0000,   0xfff,  x7,   1)
  TEST_R_IMM( 10,       sltiu,  0,      x5,   0x0000ffff0000ffff,   0x001,  x7,   0)
  TEST_R_IMM( 11,       sltiu,  0,      x5,   0xf0f0f0f0f0f0f0f0,   0xf0f,  x7,   1)

  TEST_R_IMM( 12,       sltiu,  0,      x10,  0x0000000000008fff,   0xfff,  x12,  1)
  TEST_R_IMM( 13,       sltiu,  0,      x13,  0x0000000000000001,   0x001,  x15,  0)
  TEST_R_IMM( 14,       sltiu,  0,      x12,  0xffff0000ffff0002,   0xf0f,  x11,  1)
  TEST_R_IMM( 15,       sltiu,  0,      x17,  0x0000000010000000,   0xf0f,  x13,  1)  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 16,       sltiu,  0,      x7,   0x20,   0x011,  x7,   0)
  TEST_R_IMM( 17,       sltiu,  0,      x7,   0x2f,   0x030,  x7,   1)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 18,       sltiu,  0,      x0,   0x20,   0x021,  x7,   1)
  TEST_R_IMM( 19,       sltiu,  0,      x7,   0x20,   0x031,  x0,   0)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //              testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM_BYP( 20,       sltiu,  0,      x5,   -0x30,  0x010,  x10,  0)
  TEST_R_IMM_BYP( 21,       sltiu,  1,      x5,   0x30,   0x011,  x10,  0)
  TEST_R_IMM_BYP( 22,       sltiu,  2,      x5,   0x30,   -0x042, x10,  1)
  TEST_R_IMM_BYP( 23,       sltiu,  4,      x5,   -0x30,  -0x014, x10,  1)

  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 24,       sltiu,  1,      x5,   0x20,   0x021,  x7,   1)
  TEST_R_IMM( 25,       sltiu,  2,      x5,   0x21,   0x021,  x7,   0)
  TEST_R_IMM( 26,       sltiu,  4,      x5,   -0x24,  0x022,  x7,   0)
  TEST_R_IMM( 27,       sltiu,  8,      x5,   0x28,   0x030,  x7,   1)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
