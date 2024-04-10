/*
 * File: candi.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-09-29 02:39:01 pm
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
TEST_INIT(24)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //             LOGIC
  // ------------------------------
  //            testnum,  instr,    nnop,   rds1, v1,                   imm,    vr
  TEST_C_R_IMM( 0,        c.andi,   0,      x8,   0x0000000000000000,   0x00,   0x0000000000000000)
  TEST_C_R_IMM( 1,        c.andi,   0,      x8,   0x0000000000000001,   0x01,   0x0000000000000001)
  TEST_C_R_IMM( 2,        c.andi,   0,      x8,   0x0000000000000008,   0x08,   0x0000000000000008)

  TEST_C_R_IMM( 3,        c.andi,   0,      x8,   0xffffffffffffffff,   0x00,   0x0000000000000000)
  TEST_C_R_IMM( 4,        c.andi,   0,      x8,   0xffffffff80000000,   0x3f,   0xffffffff80000000)
  TEST_C_R_IMM( 5,        c.andi,   0,      x8,   0x0000000000000000,   0x3f,   0x0000000000000000)

  TEST_C_R_IMM( 6,        c.andi,   0,      x8,   0x0000000000000002,   0x3f,   0x0000000000000002)
  TEST_C_R_IMM( 7,        c.andi,   0,      x8,   0xffffffffffffffff,   0x3f,   0xffffffffffffffff)
  TEST_C_R_IMM( 8,        c.andi,   0,      x8,   0x000000000000ffff,   0x01,   0x0000000000000001)

  TEST_C_R_IMM( 9,        c.andi,   0,      x8,   0xffffffff00000000,   0x3f,   0xffffffff00000000)
  TEST_C_R_IMM( 10,       c.andi,   0,      x8,   0x00000000ffffffff,   0x01,   0x0000000000000001)
  TEST_C_R_IMM( 11,       c.andi,   0,      x8,   0xf0f0f0f0f0f0f0ff,   0x0f,   0x000000000000000f)

  TEST_C_R_IMM( 12,       c.andi,   0,      x10,  0x0000000000008fff,   0x3f,   0x0000000000008fff)
  TEST_C_R_IMM( 13,       c.andi,   0,      x13,  0x0000000000000001,   0x01,   0x0000000000000001)
  TEST_C_R_IMM( 14,       c.andi,   0,      x12,  0xffff0000ffff0002,   0x33,   0xffff0000ffff0002)
  TEST_C_R_IMM( 15,       c.andi,   0,      x15,  0x0000000010000000,   0x20,   0x0000000010000000) 

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //                testnum,  instr,  nnop,   rds1, v1,     imm,    vr
  TEST_C_R_IMM_BYP( 16,       c.andi, 0,      x8,   0x3f,   0x10,   0x10)
  TEST_C_R_IMM_BYP( 17,       c.andi, 1,      x8,   0x3f,   0x11,   0x11)
  TEST_C_R_IMM_BYP( 18,       c.andi, 2,      x8,   0x3f,   0x12,   0x12)
  TEST_C_R_IMM_BYP( 19,       c.andi, 4,      x8,   0x3f,   0x14,   0x14)

  //            testnum,  instr,  nnop,   rds1, v1,     imm,    vr
  TEST_C_R_IMM( 20,       c.andi, 1,      x8,   0x20,   0x21,   0x20)
  TEST_C_R_IMM( 21,       c.andi, 2,      x8,   0x21,   0x21,   0x21)
  TEST_C_R_IMM( 22,       c.andi, 4,      x8,   0x24,   0x22,   0x20)
  TEST_C_R_IMM( 23,       c.andi, 8,      x8,   0x28,   0x30,   0x20)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
