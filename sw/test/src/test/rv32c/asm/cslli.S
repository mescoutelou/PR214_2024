/*
 * File: cslli.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-03 02:22:21 pm
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
  //            testnum,  instr,  nnop,   rds1, v1,                   imm,  vr
  TEST_C_R_IMM( 0,        c.slli, 0,      x8,   0x0000000000000000,   1,    0x0000000000000000)

  TEST_C_R_IMM( 1,        c.slli, 0,      x8,   0x0000000000000001,   2,    0x0000000000000004)
  TEST_C_R_IMM( 2,        c.slli, 0,      x8,   0x0000000000000001,   1,    0x0000000000000002)
  TEST_C_R_IMM( 3,        c.slli, 0,      x8,   0x0000000000000001,   15,   0x0000000000008000)
  TEST_C_R_IMM( 4,        c.slli, 0,      x8,   0x0000000000000001,   16,   0x0000000000010000)
  TEST_C_R_IMM( 5,        c.slli, 0,      x8,   0x0000000000000001,   31,   0x0000000080000000)

  TEST_C_R_IMM( 6,        c.slli, 0,      x8,   0xffffffffffffffff,   2,    0xfffffffffffffffc)
  TEST_C_R_IMM( 7,        c.slli, 0,      x8,   0xffffffffffffffff,   1,    0xfffffffffffffffe)
  TEST_C_R_IMM( 8,        c.slli, 0,      x8,   0xffffffffffffffff,   15,   0xffffffffffff8000)
  TEST_C_R_IMM( 9,        c.slli, 0,      x8,   0xffffffffffffffff,   16,   0xffffffffffff0000)
  TEST_C_R_IMM( 10,       c.slli, 0,      x8,   0xffffffffffffffff,   31,   0xffffffff80000000)

  #if (XLEN == 64)
  TEST_C_R_IMM( 11,       c.slli, 0,      x8,   0x0000000000000001,   32,   0x0000000100000000)
  TEST_C_R_IMM( 12,       c.slli, 0,      x10,  0x0000000000000001,   50,   0x0004000000000000)
  TEST_C_R_IMM( 13,       c.slli, 0,      x4,   0x0000000000000001,   63,   0x1000000000000000)
  TEST_C_R_IMM( 14,       c.slli, 0,      x12,  0xffffffffffffffff,   32,   0xffffffff00000000)
  TEST_C_R_IMM( 15,       c.slli, 0,      x17,  0xffffffffffffffff,   63,   0x8000000000000000)
  #else 
  TEST_C_R_IMM( 11,       c.slli, 0,      x8,   0x11111111,           7,    0x88888880)
  TEST_C_R_IMM( 12,       c.slli, 0,      x10,  0x11111111,           3,    0x88888888)
  TEST_C_R_IMM( 13,       c.slli, 0,      x4,   0x11111111,           16,   0x11110000)
  TEST_C_R_IMM( 14,       c.slli, 0,      x12,  0xffffffff,           8,    0xffffff00)
  TEST_C_R_IMM( 15,       c.slli, 0,      x17,  0xffffffff,           24,   0xff000000)
  #endif

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //                testnum,  instr,  nnop,   rds1, v1,     imm,    vr
  TEST_C_R_IMM_BYP( 16,       c.slli, 0,      x8,   0x13,   2,      0x004c)
  TEST_C_R_IMM_BYP( 17,       c.slli, 1,      x8,   0x21,   1,      0x0042)
  TEST_C_R_IMM_BYP( 18,       c.slli, 2,      x8,   0x21,   2,      0x0084)
  TEST_C_R_IMM_BYP( 19,       c.slli, 4,      x8,   0x21,   4,      0x0210)

  //                testnum,  instr,  nnop,   rs1,  v1,     imm,    vr
  TEST_C_R_IMM(     20,       c.slli, 1,      x8,   0x01,   4,      0x0010)
  TEST_C_R_IMM(     21,       c.slli, 2,      x8,   0x01,   8,      0x0100)
  TEST_C_R_IMM(     22,       c.slli, 4,      x8,   0x01,   5,      0x0020)
  TEST_C_R_IMM(     23,       c.slli, 8,      x8,   0x03,   12,     0x3000)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
