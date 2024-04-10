/*
 * File: ori.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:35:33 am
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
  TEST_R_IMM( 0,        ori,    0,      x5,   0x0000000000000000,   0x000,  x7,   0x0000000000000000)
  TEST_R_IMM( 1,        ori,    0,      x5,   0x0000000000000001,   0x001,  x7,   0x0000000000000001)
  TEST_R_IMM( 2,        ori,    0,      x5,   0x0000000000000008,   0x008,  x7,   0x0000000000000008)

  TEST_R_IMM( 3,        ori,    0,      x5,   0xffffffffffffffff,   0x000,  x7,   0xffffffffffffffff)
  TEST_R_IMM( 4,        ori,    0,      x5,   0xffffffff80000000,   0x7ff,  x7,   0xffffffff800007ff)
  TEST_R_IMM( 5,        ori,    0,      x5,   0x0000000000000000,   0xfff,  x7,   0xffffffffffffffff)

  TEST_R_IMM( 6,        ori,    0,      x5,   0x0000000000000002,   0xfff,  x7,   0xffffffffffffffff)
  TEST_R_IMM( 7,        ori,    0,      x5,   0xffffffffffffffff,   0xfff,  x7,   0xffffffffffffffff)
  TEST_R_IMM( 8,        ori,    0,      x5,   0x000000000000ffff,   0x001,  x7,   0x000000000000ffff)

  TEST_R_IMM( 9,        ori,    0,      x5,   0xffffffff00000000,   0xfff,  x7,   0xffffffffffffffff)
  TEST_R_IMM( 10,       ori,    0,      x5,   0x00000000ffffffff,   0x001,  x7,   0x00000000ffffffff)
  TEST_R_IMM( 11,       ori,    0,      x5,   0xf0f0f0f0f0f0f0f0,   0xf0f,  x7,   0xffffffffffffffff)

  TEST_R_IMM( 12,       ori,    0,      x10,  0x0000000000008fff,   0xfff,  x12,  0xffffffffffffffff)
  TEST_R_IMM( 13,       ori,    0,      x13,  0x0000000000000001,   0x001,  x15,  0x0000000000000001)
  TEST_R_IMM( 14,       ori,    0,      x12,  0xffff0000ffff0002,   0xf0f,  x11,  0xffffffffffffff0f)
  TEST_R_IMM( 15,       ori,    0,      x17,  0x0000000010000000,   0xf0f,  x13,  0xffffffffffffff0f)  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 16,       ori,    0,      x7,   0x20,   0x011,  x7,   0x31)
  TEST_R_IMM( 17,       ori,    0,      x7,   0x30,   0x030,  x7,   0x30)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 18,       ori,    0,      x0,   0x20,   0x021,  x7,   0x21)
  TEST_R_IMM( 19,       ori,    0,      x7,   0x20,   0x031,  x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //              testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM_BYP( 20,       ori,    0,      x5,   0x40,   0x010,  x10,  0x50)
  TEST_R_IMM_BYP( 21,       ori,    1,      x5,   0x40,   0x011,  x10,  0x51)
  TEST_R_IMM_BYP( 22,       ori,    2,      x5,   0x40,   0x012,  x10,  0x52)
  TEST_R_IMM_BYP( 23,       ori,    4,      x5,   0x40,   0x014,  x10,  0x54)

  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 24,       ori,    1,      x5,   0x20,   0x021,  x7,   0x21)
  TEST_R_IMM( 25,       ori,    2,      x5,   0x21,   0x021,  x7,   0x21)
  TEST_R_IMM( 26,       ori,    4,      x5,   0x24,   0x022,  x7,   0x26)
  TEST_R_IMM( 27,       ori,    8,      x5,   0x28,   0x030,  x7,   0x38)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
