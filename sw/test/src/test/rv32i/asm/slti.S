/*
 * File: slti.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:36:00 am
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
  //          testnum,  instr,  nnop,   rs1,  v1,                   imm,    rd,   vr
  TEST_R_IMM( 0,        slti,   0,      x5,   0x0000000000000000,   0x000,  x7,   0)
  TEST_R_IMM( 1,        slti,   0,      x5,   0x0000000000000001,   0x002,  x7,   1)
  TEST_R_IMM( 2,        slti,   0,      x5,   0x0000000000000009,   0x008,  x7,   0)

  TEST_R_IMM( 3,        slti,   0,      x5,   0xffffffffffffffff,   0x000,  x7,   1)
  TEST_R_IMM( 4,        slti,   0,      x5,   0xffffffff80000000,   0x7ff,  x7,   1)
  TEST_R_IMM( 5,        slti,   0,      x5,   0x0000000000000000,   0xfff,  x7,   0)

  TEST_R_IMM( 6,        slti,   0,      x5,   0x0000000000000002,   0xfff,  x7,   0)
  TEST_R_IMM( 7,        slti,   0,      x5,   0xffffffffffffffff,   0xfff,  x7,   0)
  TEST_R_IMM( 8,        slti,   0,      x5,   0x000000000000ffff,   0x001,  x7,   0)

  TEST_R_IMM( 9,        slti,   0,      x5,   0xffff0000ffff0000,   0xfff,  x7,   1)
  TEST_R_IMM( 10,       slti,   0,      x5,   0x0000ffff0000ffff,   0x001,  x7,   0)
  TEST_R_IMM( 11,       slti,   0,      x5,   0xf0f0f0f0f0f0f0f0,   0xf0f,  x7,   1)

  TEST_R_IMM( 12,       slti,   0,      x10,  0x0000000000008fff,   0xfff,  x12,  0)
  TEST_R_IMM( 13,       slti,   0,      x13,  0x0000000000000001,   0x001,  x15,  0)
  TEST_R_IMM( 14,       slti,   0,      x12,  0xffff0000ffff0002,   0xf0f,  x11,  1)
  TEST_R_IMM( 15,       slti,   0,      x17,  0x0000000010000000,   0xf0f,  x13,  0)  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 16,       slti,   0,      x7,   0x20,   0x011,  x7,   0)
  TEST_R_IMM( 17,       slti,   0,      x7,   0x2f,   0x030,  x7,   1)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 18,       slti,   0,      x0,   0x20,   0x021,  x7,   1)
  TEST_R_IMM( 19,       slti,   0,      x7,   0x20,   0x031,  x0,   0)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //              testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM_BYP( 20,       slti,   0,      x5,   -0x30,  0x010,  x10,  1)
  TEST_R_IMM_BYP( 21,       slti,   1,      x5,   0x30,   0x011,  x10,  0)
  TEST_R_IMM_BYP( 22,       slti,   2,      x5,   0x30,   -0x042, x10,  0)
  TEST_R_IMM_BYP( 23,       slti,   4,      x5,   -0x30,  -0x014, x10,  1)

  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 24,       slti,   1,      x5,   0x20,   0x021,  x7,   1)
  TEST_R_IMM( 25,       slti,   2,      x5,   0x21,   0x021,  x7,   0)
  TEST_R_IMM( 26,       slti,   4,      x5,   -0x24,  0x022,  x7,   1)
  TEST_R_IMM( 27,       slti,   8,      x5,   0x28,   0x030,  x7,   1)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
