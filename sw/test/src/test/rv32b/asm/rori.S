/*
 * File: rori.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-18 08:53:56 am
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
TEST_INIT(32)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //             LOGIC
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,                 imm,  rd,   vr
  TEST_R_IMM( 0,        rori,   0,      x5,   0x0000000000000000, 0,    x7,   0x0000000000000000)

  TEST_R_IMM( 1,        rori,   0,      x5,   0x0000000100000001, 0,    x7,   0x0000000100000001)
  TEST_R_IMM( 2,        rori,   0,      x5,   0x0000000100000001, 1,    x7,   0x8000000080000000)
  TEST_R_IMM( 3,        rori,   0,      x5,   0x0000000100000001, 15,   x7,   0x0002000000020000)
  TEST_R_IMM( 4,        rori,   0,      x5,   0x0000000100000001, 16,   x7,   0x0001000000010000)
  TEST_R_IMM( 5,        rori,   0,      x5,   0x0000000100000001, 31,   x7,   0x0000000200000002)

  TEST_R_IMM( 6,        rori,   0,      x5,   0xffffffffffffffff, 0,    x7,   0xffffffffffffffff)
  TEST_R_IMM( 7,        rori,   0,      x5,   0xffffffffffffffff, 1,    x7,   0xffffffffffffffff)
  TEST_R_IMM( 8,        rori,   0,      x5,   0xefffffffefffffff, 16,   x7,   0xffffefffffffefff)
  TEST_R_IMM( 9,        rori,   0,      x5,   0xffffffffffffffff, 16,   x7,   0xffffffffffffffff)
  TEST_R_IMM( 10,       rori,   0,      x5,   0xefffffffefffffff, 31,   x7,   0xdfffffffdfffffff)

  #if (XLEN == 64)
  TEST_R_IMM( 11,       rori,   0,      x5,   0x1000000000000001, 32,   x7,   0x0000000110000000)
  TEST_R_IMM( 12,       rori,   0,      x10,  0x1000000000000001, 50,   x12,  0x0000000000004400)
  TEST_R_IMM( 13,       rori,   0,      x13,  0x1000000000000001, 63,   x15,  0x0000000000000022)
  TEST_R_IMM( 14,       rori,   0,      x12,  0xffffffffffffffff, 32,   x11,  0xffffffffffffffff)
  TEST_R_IMM( 15,       rori,   0,      x17,  0xffffffffffff0000, 16,   x13,  0x0000ffffffffffff)
  #else
  TEST_R_IMM( 11,       rori,   0,      x5,   0x10000001,         16,   x7,   0x00011000)
  TEST_R_IMM( 12,       rori,   0,      x10,  0x10000001,         18,   x12,  0x00004400)
  TEST_R_IMM( 13,       rori,   0,      x13,  0x10000001,         31,   x15,  0x20000002)
  TEST_R_IMM( 14,       rori,   0,      x12,  0xffffffff,         0,    x11,  0xffffffff)
  TEST_R_IMM( 15,       rori,   0,      x17,  0xefffffff,         31,   x13,  0xdfffffff)
  #endif
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 16,       rori,   0,      x7,   0x20,   1,      x7,   0x0000000000000010)
  TEST_R_IMM( 17,       rori,   0,      x5,   0xc4,   2,      x7,   0x0000000000000031)
  TEST_R_IMM( 18,       rori,   0,      x7,   0x20,   3,      x7,   0x0000000000000004)
  TEST_R_IMM( 19,       rori,   0,      x7,   0x30,   0,      x7,   0x0000000000000030)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 20,       rori,   0,      x0,   0x20,   2,      x7,   0x00)
  TEST_R_IMM( 21,       rori,   0,      x5,   0x44,   0,      x7,   0x44)
  TEST_R_IMM( 22,       rori,   0,      x0,   0x00,   3,      x7,   0x00)
  TEST_R_IMM( 23,       rori,   0,      x5,   0x30,   1,      x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //              testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM_BYP( 24,       rori,   0,      x5,   0x108,  0,      x10,  0x0108)
  TEST_R_IMM_BYP( 25,       rori,   1,      x5,   0x108,  1,      x10,  0x0084)
  TEST_R_IMM_BYP( 26,       rori,   2,      x5,   0x108,  2,      x10,  0x0042)
  TEST_R_IMM_BYP( 27,       rori,   4,      x5,   0x108,  3,      x10,  0x0021)

  //          testnum,  instr,  nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 28,       rori,   1,      x5,   0x1000, 4,      x7,   0x0100)
  TEST_R_IMM( 29,       rori,   2,      x5,   0x1000, 8,      x7,   0x0010)
  TEST_R_IMM( 30,       rori,   8,      x5,   0x1000, 12,     x7,   0x0001)
  TEST_R_IMM( 31,       rori,   4,      x5,   0x3000, 12,     x7,   0x0003)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
