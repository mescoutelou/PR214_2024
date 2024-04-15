/*
 * File: sh2add.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-25 11:30:16 am
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
  TEST_RR_S12(0,        sh2add, 0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(1,        sh2add, 0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000001, x7,   0x0000000000000005)
  TEST_RR_S12(2,        sh2add, 0,      0,      x5,   0x0000000000000008, x6,   0x0000000000000008, x7,   0x0000000000000028)

  TEST_RR_S12(3,        sh2add, 0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000000, x7,   0xfffffffffffffffc)
  TEST_RR_S12(4,        sh2add, 0,      0,      x5,   0xffffffff80000000, x6,   0xffffffff80000000, x7,   0x0000000c80000000)
  TEST_RR_S12(5,        sh2add, 0,      0,      x5,   0x0000000000000000, x6,   0xffffffffffffffff, x7,   0xffffffffffffffff)

  TEST_RR_S12(6,        sh2add, 0,      0,      x5,   0x0000000000000002, x6,   0xffffffffffffffff, x7,   0x0000000000000007)
  TEST_RR_S12(7,        sh2add, 0,      0,      x5,   0xffffffffffffffff, x6,   0xffffffffffffffff, x7,   0xfffffffffffffffb)
  TEST_RR_S12(8,        sh2add, 0,      0,      x5,   0x000000000000ffff, x6,   0x000000000000ffff, x7,   0x000000000004fffb)

  TEST_RR_S12(9,        sh2add, 0,      0,      x5,   0xffffffff00000000, x6,   0x00000000ffffffff, x7,   0xfffffffcffffffff)
  TEST_RR_S12(10,       sh2add, 0,      0,      x5,   0x00000000ffffffff, x6,   0x0000000000000001, x7,   0x00000003fffffffd)
  TEST_RR_S12(11,       sh2add, 0,      0,      x5,   0xf0f0f0f0f0f0f0f0, x6,   0x0f0f0f0f0f0f0f0f, x7,   0xd2d2d2d2d2d2d2cf)

  TEST_RR_S12(12,       sh2add, 0,      0,      x10,  0x0000000000008fff, x11,  0x0000000000007000, x12,  0x000000000002affc)
  TEST_RR_S12(13,       sh2add, 0,      0,      x13,  0x0000000000000001, x14,  0xffffffffffffffff, x15,  0x0000000000000003)
  TEST_RR_S12(14,       sh2add, 0,      0,      x12,  0xffff0000ffff0002, x10,  0x0000ffff0000ffff, x11,  0xfffd0002fffd0007)
  TEST_RR_S12(15,       sh2add, 0,      0,      x17,  0x0000000010000000, x10,  0x000000000fffffff, x13,  0x000000004fffffff)
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       sh2add, 0,      0,      x7,   0x20,   x6,   0x11,   x7,   0x91)
  TEST_RR_S12(17,       sh2add, 0,      0,      x5,   0x11,   x7,   0x02,   x7,   0x46)
  TEST_RR_S12(18,       sh2add, 0,      0,      x7,   0x00,   x7,   0x12,   x7,   0x5a)

  TEST_RR_S21(19,       sh2add, 0,      0,      x7,   0x20,   x7,   0x00,   x7,   0xa0)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       sh2add, 0,      0,      x0,   0x20,   x6,   0x11,   x7,   0x11)
  TEST_RR_S12(21,       sh2add, 0,      0,      x5,   0x22,   x0,   0x02,   x7,   0x88)
  TEST_RR_S12(22,       sh2add, 0,      0,      x0,   0x00,   x0,   0x12,   x7,   0x00)
  TEST_RR_S12(23,       sh2add, 0,      0,      x5,   0x30,   x6,   0x20,   x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,   rd,   vr
  TEST_RR_BYP(24,       sh2add, 0,      x5,   0x20,   x6,   0x10, x10,  0x90)
  TEST_RR_BYP(25,       sh2add, 1,      x5,   0x20,   x6,   0x11, x10,  0x91)
  TEST_RR_BYP(26,       sh2add, 2,      x5,   0x20,   x6,   0x12, x10,  0x92)
  TEST_RR_BYP(27,       sh2add, 4,      x5,   0x20,   x6,   0x14, x10,  0x94)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,   rs2,  v2,   rd,   vr
  TEST_RR_S12(28,       sh2add, 1,      0,      x5,   0x30, x6,   0x20, x7,   0xe0)
  TEST_RR_S12(29,       sh2add, 1,      1,      x5,   0x30, x6,   0x21, x7,   0xe1)

  TEST_RR_S21(30,       sh2add, 1,      0,      x5,   0x30, x6,   0x22, x7,   0xe2)
  TEST_RR_S21(31,       sh2add, 1,      1,      x5,   0x30, x6,   0x23, x7,   0xe3)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
