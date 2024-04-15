/*
 * File: caddi.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-09-28 02:45:12 pm
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
TEST_INIT(26)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //           ARITHMETIC
  // ------------------------------

  //            testnum,  instr,  nnop,   rds1, v1,                   imm,    vr
  TEST_C_R_IMM( 0,        c.addi, 0,      x5,   0x0000000000000000,   0,      0x0000000000000000)
  TEST_C_R_IMM( 1,        c.addi, 0,      x5,   0x0000000000000001,   1,      0x0000000000000002)
  TEST_C_R_IMM( 2,        c.addi, 0,      x5,   0x0000000000000008,   8,      0x0000000000000010)

  TEST_C_R_IMM( 3,        c.addi, 0,      x5,   0xffffffffffffffff,   0,      0xffffffffffffffff)
  TEST_C_R_IMM( 4,        c.addi, 0,      x5,   0xffffffff80000000,   -1,     0xffffffff7fffffff)
  TEST_C_R_IMM( 5,        c.addi, 0,      x5,   0x0000000000000000,   -1,     0xffffffffffffffff)

  TEST_C_R_IMM( 6,        c.addi, 0,      x5,   0x0000000000000002,   -1,     0x0000000000000001)
  TEST_C_R_IMM( 7,        c.addi, 0,      x5,   0xffffffffffffffff,   -1,     0xfffffffffffffffe)
  TEST_C_R_IMM( 8,        c.addi, 0,      x5,   0x000000000000ffff,   1,      0x0000000000010000)

  TEST_C_R_IMM( 9,        c.addi, 0,      x5,   0xffffffff00000000,   -1,     0xfffffffeffffffff)
  TEST_C_R_IMM( 10,       c.addi, 0,      x5,   0x00000000ffffffff,   1,      0x0000000100000000)
  TEST_C_R_IMM( 11,       c.addi, 0,      x5,   0xf0f0f0f0f0f0f0f0,   -1,     0xf0f0f0f0f0f0f0ef)

  TEST_C_R_IMM( 12,       c.addi, 0,      x10,  0x0000000000008fff,   -1,     0x0000000000008ffe)
  TEST_C_R_IMM( 13,       c.addi, 0,      x13,  0x0000000000000001,   1,      0x0000000000000002)
  TEST_C_R_IMM( 14,       c.addi, 0,      x15,  0xffff0000ffff0002,   -1,     0xffff0000ffff0001)
  TEST_C_R_IMM( 15,       c.addi, 0,      x12,  0x0000000010000000,   -16,    0x000000000ffffff0) 

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //            testnum,  instr,  nnop,   rds1, v1,                   imm,    vr
  TEST_C_R_IMM( 16,       c.addi, 0,      x0,   0x0000000000000000,   15,     0x00)
  TEST_C_R_IMM( 17,       c.addi, 0,      x0,   0x0000000000000000,   -14,    0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //                testnum,  instr,  nnop,   rs1,  v1,     imm,    vr
  TEST_C_R_IMM_BYP( 18,       c.addi, 0,      x5,   0x30,   0x10,   0x40)
  TEST_C_R_IMM_BYP( 19,       c.addi, 1,      x5,   0x30,   0x11,   0x41)
  TEST_C_R_IMM_BYP( 20,       c.addi, 2,      x5,   0x30,   0x12,   0x42)
  TEST_C_R_IMM_BYP( 21,       c.addi, 4,      x5,   0x30,   0x14,   0x44)

  //            testnum,  instr,  nnop,   rds1, v1,     imm,    vr
  TEST_C_R_IMM( 22,       c.addi, 1,      x5,   0x20,   0x11,  0x31)
  TEST_C_R_IMM( 23,       c.addi, 2,      x5,   0x21,   0x11,  0x32)
  TEST_C_R_IMM( 24,       c.addi, 4,      x5,   0x24,   0x12,  0x36)
  TEST_C_R_IMM( 25,       c.addi, 8,      x5,   0x28,   0x10,  0x38)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
