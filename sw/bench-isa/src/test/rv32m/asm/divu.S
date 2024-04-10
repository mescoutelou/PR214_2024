/*
 * File: divu.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:32:59 am
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
  TEST_RR_S12(0,        divu,   0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0xffffffffffffffff)
  TEST_RR_S12(1,        divu,   0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000001, x7,   0x0000000000000001)
  TEST_RR_S12(2,        divu,   0,      0,      x5,   0x0000000000000011, x6,   0x0000000000000008, x7,   0x0000000000000002)

  TEST_RR_S12(3,        divu,   0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000001, x7,   0xffffffffffffffff)
  #if (XLEN == 64)
  TEST_RR_S12(4,        divu,   0,      0,      x5,   0x8000000000000000, x6,   0xffffffffffffffff, x7,   0x0000000000000000)
  #else
  TEST_RR_S12(4,        divu,   0,      0,      x5,   0x80000000,         x6,   0xffffffff,         x7,   0x00000000)
  #endif
  TEST_RR_S12(5,        divu,   0,      0,      x5,   0x0000000000000000, x6,   0xffffffffffffffff, x7,   0x0000000000000000)

  TEST_RR_S12(6,        divu,   0,      0,      x5,   0x0000000000000001, x6,   0xffffffffffffffff, x7,   0x0000000000000000)
  TEST_RR_S12(7,        divu,   0,      0,      x5,   0xfedcba9876543210, x6,   0x0000000000000001, x7,   0xfedcba9876543210)
  TEST_RR_S12(8,        divu,   0,      0,      x5,   0x00000000000ffff0, x6,   0x000000000000ffff, x7,   0x0000000000000010)

  #if (XLEN == 64)
  TEST_RR_S12(9,        divu,   0,      0,      x5,   0xaaaaaaaaaaaaaaaa, x6,   0x0000000000001234, x7,   0x0009602c88d389ec)
  #else
  TEST_RR_S12(9,        divu,   0,      0,      x5,   0xaaaaaaaa,         x6,   0x00001234,         x7,   0x0009602c)
  #endif
  TEST_RR_S12(10,       divu,   0,      0,      x5,   0x000000004f4f4f4f, x6,   0x000000004f000000, x7,   0x0000000000000001)
  TEST_RR_S12(11,       divu,   0,      0,      x5,   0x0000000000050000, x6,   0x0000000000000400, x7,   0x0000000000000140)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,       rd,   vr
  TEST_RR_S12(12,       divu,   0,      0,      x10,  0x0001, x11,  0xffff,   x12,  0x0000)
  TEST_RR_S12(13,       divu,   0,      0,      x13,  0x0002, x14,  0x0002,   x15,  0x0001)
  TEST_RR_S12(14,       divu,   0,      0,      x12,  0x0100, x10,  0x0010,   x11,  0x0010)
  #if (XLEN == 64)
  TEST_RR_S12(15,       divu,   0,      0,      x17,  -1,     x10,  0xffff,   x13,  0x1000100010001)
  #else
  TEST_RR_S12(15,       divu,   0,      0,      x17,  -1,     x10,  0xffff,   x13,  0x10001)
  #endif
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       divu,   0,      0,      x7,   0x20,   x6,   0x11,   x7,   0x01)
  TEST_RR_S12(17,       divu,   0,      0,      x5,   0x44,   x7,   0x02,   x7,   0x22)
  TEST_RR_S12(18,       divu,   0,      0,      x7,   0x00,   x7,   0x12,   x7,   0x01)

  TEST_RR_S21(19,       divu,   0,      0,      x7,   0x30,   x7,   0x00,   x7,   0x01)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       divu,   0,      0,      x0,   0x22,   x6,   0x11,   x7,   0x00)
  TEST_RR_S12(21,       divu,   0,      0,      x5,   0x58,   x0,   0x02,   x7,   -0x1)
  TEST_RR_S12(22,       divu,   0,      0,      x0,   0x00,   x0,   0x12,   x7,   -0x1)
  TEST_RR_S12(23,       divu,   0,      0,      x5,   0x30,   x6,   0x20,   x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_BYP(24,       divu,   0,      x5,   0x20,   x6,   0x10,   x10,  0x02)
  TEST_RR_BYP(25,       divu,   1,      x5,   0x20,   x6,   0x11,   x10,  0x01)
  TEST_RR_BYP(26,       divu,   2,      x5,   0x36,   x6,   0x12,   x10,  0x03)
  TEST_RR_BYP(27,       divu,   4,      x5,   0x96,   x6,   0x14,   x10,  0x07)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,   rs2,  v2,     rd,   vr
  TEST_RR_S12(28,       divu,   1,      0,      x5,   0x30, x6,   0x20,   x7,   0x01)
  TEST_RR_S12(29,       divu,   1,      1,      x5,   0x30, x6,   0x21,   x7,   0x01)

  TEST_RR_S21(30,       divu,   1,      0,      x5,   0x90, x6,   0x22,   x7,   0x04)
  TEST_RR_S21(31,       divu,   1,      1,      x5,   0x30, x6,   0x23,   x7,   0x01)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
