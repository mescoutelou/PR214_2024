/*
 * File: sll.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-04 09:04:33 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "../../../common/macro.h"
#include "../../../common/macro-rr.h"


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
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                 rs2,  v2,   rd,   vr
  TEST_RR_S12(0,        sll,    0,      0,      x5,   0x0000000000000000, x6,   0,    x7,   0x0000000000000000)

  TEST_RR_S12(1,        sll,    0,      0,      x5,   0x0000000000000001, x6,   0,    x7,   0x0000000000000001)
  TEST_RR_S12(2,        sll,    0,      0,      x5,   0x0000000000000001, x6,   1,    x7,   0x0000000000000002)
  TEST_RR_S12(3,        sll,    0,      0,      x5,   0x0000000000000001, x6,   15,   x7,   0x0000000000008000)
  TEST_RR_S12(4,        sll,    0,      0,      x5,   0x0000000000000001, x6,   16,   x7,   0x0000000000010000)
  TEST_RR_S12(5,        sll,    0,      0,      x5,   0x0000000000000001, x6,   31,   x7,   0x0000000080000000)

  TEST_RR_S12(6,        sll,    0,      0,      x5,   0xffffffffffffffff, x6,   0,    x7,   0xffffffffffffffff)
  TEST_RR_S12(7,        sll,    0,      0,      x5,   0xffffffffffffffff, x6,   1,    x7,   0xfffffffffffffffe)
  TEST_RR_S12(8,        sll,    0,      0,      x5,   0xffffffffffffffff, x6,   15,   x7,   0xffffffffffff8000)
  TEST_RR_S12(9,        sll,    0,      0,      x5,   0xffffffffffffffff, x6,   16,   x7,   0xffffffffffff0000)
  TEST_RR_S12(10,       sll,    0,      0,      x5,   0xffffffffffffffff, x6,   31,   x7,   0xffffffff80000000)

  #if (XLEN == 64)
  TEST_RR_S12(11,       sll,    0,      0,      x5,   0x0000000000000001, x6,   32,   x7,   0x0000000100000000)
  TEST_RR_S12(12,       sll,    0,      0,      x10,  0x0000000000000001, x11,  50,   x12,  0x0004000000000000)
  TEST_RR_S12(13,       sll,    0,      0,      x13,  0x0000000000000001, x14,  63,   x15,  0x1000000000000000)
  TEST_RR_S12(14,       sll,    0,      0,      x12,  0xffffffffffffffff, x10,  32,   x11,  0xffffffff00000000)
  TEST_RR_S12(15,       sll,    0,      0,      x17,  0xffffffffffffffff, x10,  63,   x13,  0x8000000000000000)
  #else
  TEST_RR_S12(11,       sll,    0,      0,      x5,   0x00000001,         x6,   32,   x7,   0x00000001)
  TEST_RR_S12(12,       sll,    0,      0,      x10,  0x00000001,         x11,  50,   x12,  0x00040000)
  TEST_RR_S12(13,       sll,    0,      0,      x13,  0x00000001,         x14,  63,   x15,  0x80000000)
  TEST_RR_S12(14,       sll,    0,      0,      x12,  0xffffffff,         x10,  32,   x11,  0xffffffff)
  TEST_RR_S12(15,       sll,    0,      0,      x17,  0xffffffff,         x10,  63,   x13,  0x80000000)
  #endif
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       sll,    0,      0,      x7,   0x20,   x6,   1,      x7,   0x000040)
  TEST_RR_S12(17,       sll,    0,      0,      x5,   0x31,   x7,   2,      x7,   0x0000c4)
  TEST_RR_S12(18,       sll,    0,      0,      x7,   0x22,   x7,   3,      x7,   0x000018)

  TEST_RR_S21(19,       sll,    0,      0,      x7,   0x30,   x7,   0,      x7,   0x300000)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       sll,    0,      0,      x0,   0x20,   x6,   2,      x7,   0x00)
  TEST_RR_S12(21,       sll,    0,      0,      x5,   0x44,   x0,   2,      x7,   0x44)
  TEST_RR_S12(22,       sll,    0,      0,      x0,   0x00,   x0,   3,      x7,   0x00)
  TEST_RR_S12(23,       sll,    0,      0,      x5,   0x30,   x6,   1,      x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_BYP(24,       sll,    0,      x5,   0x21,   x6,   0,      x10,  0x0021)
  TEST_RR_BYP(25,       sll,    1,      x5,   0x21,   x6,   1,      x10,  0x0042)
  TEST_RR_BYP(26,       sll,    2,      x5,   0x21,   x6,   2,      x10,  0x0084)
  TEST_RR_BYP(27,       sll,    4,      x5,   0x21,   x6,   3,      x10,  0x0108)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,   rd,   vr
  TEST_RR_S12(28,       sll,    1,      0,      x5,   0x01,   x6,   4,    x7,   0x0010)
  TEST_RR_S12(29,       sll,    1,      1,      x5,   0x01,   x6,   8,    x7,   0x0100)

  TEST_RR_S21(30,       sll,    1,      0,      x5,   0x01,   x6,   12,    x7,  0x1000)
  TEST_RR_S21(31,       sll,    1,      1,      x5,   0x03,   x6,   12,    x7,  0x3000)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
