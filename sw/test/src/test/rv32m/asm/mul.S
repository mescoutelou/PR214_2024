/*
 * File: mul.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:33:03 am
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
  TEST_RR_S12(0,        mul,    0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(1,        mul,    0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000001, x7,   0x0000000000000001)
  TEST_RR_S12(2,        mul,    0,      0,      x5,   0x0000000000000008, x6,   0x0000000000000008, x7,   0x0000000000000040)

  TEST_RR_S12(3,        mul,    0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(4,        mul,    0,      0,      x5,   0xffffffff80000000, x6,   0xffffffff80000000, x7,   0x0000000000000000)
  TEST_RR_S12(5,        mul,    0,      0,      x5,   0x0000000000000000, x6,   0xffffffffffffffff, x7,   0x0000000000000000)

  TEST_RR_S12(6,        mul,    0,      0,      x5,   0x0000000000000001, x6,   0xffffffffffffffff, x7,   0xffffffffffffffff)
  TEST_RR_S12(7,        mul,    0,      0,      x5,   0xfedcba9876543210, x6,   0x0000000000000001, x7,   0xfedcba9876543210)
  TEST_RR_S12(8,        mul,    0,      0,      x5,   0x000000000000ffff, x6,   0x000000000000ffff, x7,   0x00000000fffe0001)

  TEST_RR_S12(9,        mul,    0,      0,      x5,   0xaaaaaaaaaaaaaaaa, x6,   0x0000000000001234, x7,   0xaaaaaaaaaaaa9e88)
  TEST_RR_S12(10,       mul,    0,      0,      x5,   0x00000000ffffffff, x6,   0x0000000000000001, x7,   0x00000000ffffffff)

  #if (XLEN == 64)
  TEST_RR_S12(11,       mul,    0,      0,      x5,   0x8000000000000500, x6,   0x8000000000000400, x7,   0x0000000000140000)
  #else
  TEST_RR_S12(11,       mul,    0,      0,      x5,   0x80000500,         x6,   0x80000400,         x7,   0x00140000)
  #endif

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,       rd,   vr
  TEST_RR_S12(12,       mul,    0,      0,      x10,  0x0001, x11,  0xffff,   x12,  0xffff)
  TEST_RR_S12(13,       mul,    0,      0,      x13,  0x0002, x14,  0x0002,   x15,  0x0004)
  TEST_RR_S12(14,       mul,    0,      0,      x12,  0x0010, x10,  0x0100,   x11,  0x1000)
  TEST_RR_S12(15,       mul,    0,      0,      x17,  0x0008, x10,  -0x1111,  x13,  -0x8888)
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       mul,    0,      0,      x7,   0x20,   x6,   0x11,   x7,   0x0220)
  TEST_RR_S12(17,       mul,    0,      0,      x5,   -0x44,  x7,   0x02,   x7,   -0x0088)
  TEST_RR_S12(18,       mul,    0,      0,      x7,   0x00,   x7,   0x12,   x7,   0x0144)

  TEST_RR_S21(19,       mul,    0,      0,      x7,   0x30,   x7,   0x00,   x7,   0x0900)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       mul,    0,      0,      x0,   0x20,   x6,   0x11,   x7,   0x00)
  TEST_RR_S12(21,       mul,    0,      0,      x5,   -0x44,  x0,   0x02,   x7,   0x00)
  TEST_RR_S12(22,       mul,    0,      0,      x0,   0x00,   x0,   0x12,   x7,   0x00)
  TEST_RR_S12(23,       mul,    0,      0,      x5,   0x30,   x6,   0x20,   x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_BYP(24,       mul,    0,      x5,   0x20,   x6,   0x10,   x10,  0x0200)
  TEST_RR_BYP(25,       mul,    1,      x5,   -0x20,  x6,   0x11,   x10,  -0x0220)
  TEST_RR_BYP(26,       mul,    2,      x5,   0x20,   x6,   -0x12,  x10,  -0x0240)
  TEST_RR_BYP(27,       mul,    4,      x5,   -0x20,  x6,   -0x14,  x10,  0x0280)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,   rs2,  v2,     rd,   vr
  TEST_RR_S12(28,       mul,    1,      0,      x5,   0x30, x6,   0x20,   x7,   0x0600)
  TEST_RR_S12(29,       mul,    1,      1,      x5,   0x30, x6,   0x21,   x7,   0x0630)

  TEST_RR_S21(30,       mul,    1,      0,      x5,   0x30, x6,   0x22,   x7,   0x0660)
  TEST_RR_S21(31,       mul,    1,      1,      x5,   0x30, x6,   -0x23,  x7,   -0x0690)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
