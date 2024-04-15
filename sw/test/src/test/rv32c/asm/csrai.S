/*
 * File: csrai.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-09-29 09:23:22 am
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
  TEST_C_R_IMM( 0,        c.srai, 0,      x8,   0x0000000000000000,   1,    0x0000000000000000)

  TEST_C_R_IMM( 1,        c.srai, 0,      x8,   0x800fffff80000000,   2,    0xe003ffffe0000000)
  TEST_C_R_IMM( 2,        c.srai, 0,      x8,   0x800fffff80000000,   1,    0x4008ffffc0000000)
  TEST_C_R_IMM( 3,        c.srai, 0,      x8,   0x800fffff80000000,   15,   0xffff001fffff0000)
  TEST_C_R_IMM( 4,        c.srai, 0,      x8,   0x800fffff80000000,   16,   0xffff800fffff8000)
  #if (XLEN == 64)
  TEST_C_R_IMM( 5,        c.srai, 0,      x8,   0x800fffff80000000,   31,   0xffffffff001fffff)
  #else
  TEST_C_R_IMM( 5,        c.srai, 0,      x8,   0x80000000,           31,   0xffffffff)
  #endif

  TEST_C_R_IMM( 6,        c.srai, 0,      x8,   0x4000000040000000,   2,    0x1000000010000000)
  TEST_C_R_IMM( 7,        c.srai, 0,      x8,   0x4000000040000000,   1,    0x2000000020000000)
  TEST_C_R_IMM( 8,        c.srai, 0,      x8,   0x4000000040000000,   15,   0x0000800000008000)
  TEST_C_R_IMM( 9,        c.srai, 0,      x8,   0x4000000040000000,   16,   0x0000400000004000)
  #if (XLEN == 64)
  TEST_C_R_IMM( 10,       c.srai, 0,      x8,   0x4000000040000000,   31,   0x0000000080000000)
  #else
  TEST_C_R_IMM( 10,       c.srai, 0,      x8,   0x40000000,           31,   0x00000000)
  #endif

  #if (XLEN == 64)
  TEST_C_R_IMM( 11,       c.srai, 0,      x8,   0x8000000000000000,   32,   0xffffffff80000000)
  TEST_C_R_IMM( 12,       c.srai, 0,      x10,  0x8000000000000000,   50,   0xffffffffffffe000)
  TEST_C_R_IMM( 13,       c.srai, 0,      x13,  0x8000000000000000,   63,   0xffffffffffffffff)
  TEST_C_R_IMM( 14,       c.srai, 0,      x12,  0x7fffffffffffffff,   32,   0x000000007fffffff)
  TEST_C_R_IMM( 15,       c.srai, 0,      x15,  0x7fffffffffffffff,   63,   0x0000000000000000)
  #else 
  TEST_C_R_IMM( 11,       c.srai, 0,      x8,   0x80000000,           7,    0xff000000)
  TEST_C_R_IMM( 12,       c.srai, 0,      x10,  0x80000000,           3,    0xf0000000)
  TEST_C_R_IMM( 13,       c.srai, 0,      x13,  0x80000000,           16,   0xffff8000)
  TEST_C_R_IMM( 14,       c.srai, 0,      x12,  0x7fffffff,           8,    0x007fffff)
  TEST_C_R_IMM( 15,       c.srai, 0,      x15,  0x7fffffff,           24,   0x0000007f)
  #endif

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //                testnum,  instr,  nnop,   rds1, v1,       imm,    vr
  TEST_C_R_IMM_BYP( 16,       c.srai, 0,      x8,   0x13,     1,      0x09)
  TEST_C_R_IMM_BYP( 17,       c.srai, 1,      x8,   -0x48,    1,      -0x24)
  TEST_C_R_IMM_BYP( 18,       c.srai, 2,      x8,   -0x48,    2,      -0x12)
  TEST_C_R_IMM_BYP( 19,       c.srai, 4,      x8,   0x48,     3,      0x09)

  //                testnum,  instr,  nnop,   rds1, v1,       imm,    vr
  TEST_C_R_IMM(     20,       c.srai, 1,      x8,   0x3010,   4,      0x0301)
  TEST_C_R_IMM(     21,       c.srai, 2,      x8,   -0x3010,  8,      -0x0031)
  TEST_C_R_IMM(     22,       c.srai, 4,      x8,   0x3010,   12,     0x0003)
  TEST_C_R_IMM(     23,       c.srai, 8,      x8,   0x9010,   12,     0x0009)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
