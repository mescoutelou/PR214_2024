/*
 * File: sh3add.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-25 11:27:44 am
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
  TEST_RR_S12(0,        sh3add, 0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(1,        sh3add, 0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000001, x7,   0x0000000000000009)
  TEST_RR_S12(2,        sh3add, 0,      0,      x5,   0x0000000000000008, x6,   0x0000000000000008, x7,   0x0000000000000048)

  TEST_RR_S12(3,        sh3add, 0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000000, x7,   0xfffffffffffffff8)
  TEST_RR_S12(4,        sh3add, 0,      0,      x5,   0xffffffff80000000, x6,   0xffffffff80000000, x7,   0x0000000880000000)
  TEST_RR_S12(5,        sh3add, 0,      0,      x5,   0x0000000000000000, x6,   0xffffffffffffffff, x7,   0xffffffffffffffff)

  TEST_RR_S12(6,        sh3add, 0,      0,      x5,   0x0000000000000002, x6,   0xffffffffffffffff, x7,   0x000000000000000f)
  TEST_RR_S12(7,        sh3add, 0,      0,      x5,   0xffffffffffffffff, x6,   0xffffffffffffffff, x7,   0xfffffffffffffff7)
  TEST_RR_S12(8,        sh3add, 0,      0,      x5,   0x000000000000ffff, x6,   0x000000000000ffff, x7,   0x000000000008fff7)

  TEST_RR_S12(9,        sh3add, 0,      0,      x5,   0xffffffff00000000, x6,   0x00000000ffffffff, x7,   0xfffffff8ffffffff)
  TEST_RR_S12(10,       sh3add, 0,      0,      x5,   0x00000000ffffffff, x6,   0x0000000000000001, x7,   0x00000007fffffff9)
  TEST_RR_S12(11,       sh3add, 0,      0,      x5,   0xf0f0f0f0f0f0f0f0, x6,   0x0f0f0f0f0f0f0f0f, x7,   0x969696969696968f)

  TEST_RR_S12(12,       sh3add, 0,      0,      x10,  0x0000000000008fff, x11,  0x0000000000007000, x12,  0x000000000004eff8)
  TEST_RR_S12(13,       sh3add, 0,      0,      x13,  0x0000000000000001, x14,  0xffffffffffffffff, x15,  0x0000000000000007)
  TEST_RR_S12(14,       sh3add, 0,      0,      x12,  0xffff0000ffff0002, x10,  0x0000ffff0000ffff, x11,  0x7ff90006fff9000f)
  TEST_RR_S12(15,       sh3add, 0,      0,      x17,  0x0000000010000000, x10,  0x000000000fffffff, x13,  0x000000008fffffff)
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       sh3add, 0,      0,      x7,   0x10,   x6,   0x11,   x7,   0x91)
  TEST_RR_S12(17,       sh3add, 0,      0,      x5,   0x11,   x7,   0x02,   x7,   0x8a)
  TEST_RR_S12(18,       sh3add, 0,      0,      x7,   0x00,   x7,   0x11,   x7,   0x99)

  TEST_RR_S21(19,       sh3add, 0,      0,      x7,   0x04,   x7,   0x00,   x7,   0x24)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       sh3add, 0,      0,      x0,   0x20,   x6,   0x11,   x7,   0x11)
  TEST_RR_S12(21,       sh3add, 0,      0,      x5,   0x12,   x0,   0x02,   x7,   0x90)
  TEST_RR_S12(22,       sh3add, 0,      0,      x0,   0x00,   x0,   0x12,   x7,   0x00)
  TEST_RR_S12(23,       sh3add, 0,      0,      x5,   0x30,   x6,   0x20,   x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,   rd,   vr
  TEST_RR_BYP(24,       sh3add, 0,      x5,   0x03,   x6,   0x10, x10,  0x28)
  TEST_RR_BYP(25,       sh3add, 1,      x5,   0x03,   x6,   0x11, x10,  0x29)
  TEST_RR_BYP(26,       sh3add, 2,      x5,   0x03,   x6,   0x12, x10,  0x2a)
  TEST_RR_BYP(27,       sh3add, 4,      x5,   0x03,   x6,   0x14, x10,  0x2c)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,   rs2,  v2,   rd,   vr
  TEST_RR_S12(28,       sh3add, 1,      0,      x5,   0x30, x6,   0x20, x7,   0x1a0)
  TEST_RR_S12(29,       sh3add, 1,      1,      x5,   0x30, x6,   0x21, x7,   0x1a1)

  TEST_RR_S21(30,       sh3add, 1,      0,      x5,   0x30, x6,   0x22, x7,   0x1a2)
  TEST_RR_S21(31,       sh3add, 1,      1,      x5,   0x30, x6,   0x23, x7,   0x1a3)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
