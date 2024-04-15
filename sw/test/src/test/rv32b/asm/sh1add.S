/*
 * File: sh1add.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-21 05:52:57 pm
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
  //           ARITHMETIC
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                 rs2,  v2,                 rd,   vr
  TEST_RR_S12(0,        sh1add, 0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(1,        sh1add, 0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000001, x7,   0x0000000000000003)
  TEST_RR_S12(2,        sh1add, 0,      0,      x5,   0x0000000000000008, x6,   0x0000000000000008, x7,   0x0000000000000018)

  TEST_RR_S12(3,        sh1add, 0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000000, x7,   0xfffffffffffffffe)
  TEST_RR_S12(4,        sh1add, 0,      0,      x5,   0xffffffff80000000, x6,   0xffffffff80000000, x7,   0x0000000e80000000)
  TEST_RR_S12(5,        sh1add, 0,      0,      x5,   0x0000000000000000, x6,   0xffffffffffffffff, x7,   0xffffffffffffffff)

  TEST_RR_S12(6,        sh1add, 0,      0,      x5,   0x0000000000000002, x6,   0xffffffffffffffff, x7,   0x0000000000000003)
  TEST_RR_S12(7,        sh1add, 0,      0,      x5,   0xffffffffffffffff, x6,   0xffffffffffffffff, x7,   0xfffffffffffffffd)
  TEST_RR_S12(8,        sh1add, 0,      0,      x5,   0x000000000000ffff, x6,   0x000000000000ffff, x7,   0x000000000002fffd)

  TEST_RR_S12(9,        sh1add, 0,      0,      x5,   0xffffffff00000000, x6,   0x00000000ffffffff, x7,   0xfffffffeffffffff)
  TEST_RR_S12(10,       sh1add, 0,      0,      x5,   0x00000000ffffffff, x6,   0x0000000000000001, x7,   0x00000001ffffffff)
  TEST_RR_S12(11,       sh1add, 0,      0,      x5,   0xf0f0f0f0f0f0f0f0, x6,   0x0f0f0f0f0f0f0f0f, x7,   0xf0f0f0f0f0f0f0ef)

  TEST_RR_S12(12,       sh1add, 0,      0,      x10,  0x0000000000008fff, x11,  0x0000000000007000, x12,  0x0000000000018ffe)
  TEST_RR_S12(13,       sh1add, 0,      0,      x13,  0x0000000000000001, x14,  0xffffffffffffffff, x15,  0x0000000000000001)
  TEST_RR_S12(14,       sh1add, 0,      0,      x12,  0xffff0000ffff0002, x10,  0x0000ffff0000ffff, x11,  0xffff0000ffff0003)
  TEST_RR_S12(15,       sh1add, 0,      0,      x17,  0x0000000010000000, x10,  0x000000000fffffff, x13,  0x000000002fffffff)
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       sh1add, 0,      0,      x7,   0x20,   x6,   0x11,   x7,   0x51)
  TEST_RR_S12(17,       sh1add, 0,      0,      x5,   0x44,   x7,   0x02,   x7,   0x8a)
  TEST_RR_S12(18,       sh1add, 0,      0,      x7,   0x00,   x7,   0x12,   x7,   0x36)

  TEST_RR_S21(19,       sh1add, 0,      0,      x7,   0x30,   x7,   0x00,   x7,   0x90)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       sh1add, 0,      0,      x0,   0x20,   x6,   0x11,   x7,   0x11)
  TEST_RR_S12(21,       sh1add, 0,      0,      x5,   0x44,   x0,   0x02,   x7,   0x88)
  TEST_RR_S12(22,       sh1add, 0,      0,      x0,   0x00,   x0,   0x12,   x7,   0x00)
  TEST_RR_S12(23,       sh1add, 0,      0,      x5,   0x30,   x6,   0x20,   x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,   rd,   vr
  TEST_RR_BYP(24,       sh1add, 0,      x5,   0x20,   x6,   0x10, x10,  0x50)
  TEST_RR_BYP(25,       sh1add, 1,      x5,   0x20,   x6,   0x11, x10,  0x51)
  TEST_RR_BYP(26,       sh1add, 2,      x5,   0x20,   x6,   0x12, x10,  0x52)
  TEST_RR_BYP(27,       sh1add, 4,      x5,   0x20,   x6,   0x14, x10,  0x54)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,   rs2,  v2,   rd,   vr
  TEST_RR_S12(28,       sh1add, 1,      0,      x5,   0x30, x6,   0x20, x7,   0x80)
  TEST_RR_S12(29,       sh1add, 1,      1,      x5,   0x30, x6,   0x21, x7,   0x81)

  TEST_RR_S21(30,       sh1add, 1,      0,      x5,   0x30, x6,   0x22, x7,   0x82)
  TEST_RR_S21(31,       sh1add, 1,      1,      x5,   0x30, x6,   0x23, x7,   0x83)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
