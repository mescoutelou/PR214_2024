/*
 * File: rem.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:33:18 am
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
  TEST_RR_S12(0,        rem,    0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(1,        rem,    0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000001, x7,   0x0000000000000000)
  TEST_RR_S12(2,        rem,    0,      0,      x5,   0x000000000000000a, x6,   0x0000000000000008, x7,   0x0000000000000002)

  TEST_RR_S12(3,        rem,    0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000001, x7,   0x0000000000000000)
  #if (XLEN == 64)
  TEST_RR_S12(4,        rem,    0,      0,      x5,   0x8000000000000000, x6,   0xffffffffffffffff, x7,   0x0000000000000000)
  #else
  TEST_RR_S12(4,        rem,    0,      0,      x5,   0x80000000,         x6,   0xffffffff,         x7,   0x00000000)
  #endif
  TEST_RR_S12(5,        rem,    0,      0,      x5,   0x0000000000000000, x6,   0xffffffffffffffff, x7,   0x0000000000000000)

  TEST_RR_S12(6,        rem,    0,      0,      x5,   0x0000000000000001, x6,   0xffffffffffffffff, x7,   0x0000000000000000)
  TEST_RR_S12(7,        rem,    0,      0,      x5,   0xfedcba9876543210, x6,   0x0000000000000001, x7,   0x0000000000000000)
  TEST_RR_S12(8,        rem,    0,      0,      x5,   0x00000000000ffffa, x6,   0x000000000000ffff, x7,   0x000000000000000a)

  TEST_RR_S12(9,        rem,    0,      0,      x5,   0x000000007aaaaaaa, x6,   0x0000000000001234, x7,   0x000000000000002a)
  TEST_RR_S12(10,       rem,    0,      0,      x5,   0x000000004f4f4f4f, x6,   0x000000004f000000, x7,   0x00000000004f4f4f)
  TEST_RR_S12(11,       rem,    0,      0,      x5,   0x0000000000050000, x6,   0x0000000000000400, x7,   0x0000000000000000)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,       rd,   vr
  TEST_RR_S12(12,       rem,    0,      0,      x10,  0x0002, x11,  0xffff,   x12,  0x02)
  TEST_RR_S12(13,       rem,    0,      0,      x13,  0x0003, x14,  0x0002,   x15,  0x01)
  TEST_RR_S12(14,       rem,    0,      0,      x12,  0x0100, x10,  0x0010,   x11,  0x00)
  TEST_RR_S12(15,       rem,    0,      0,      x17,  0x1111, x10,  -0x0008,  x13,  0x01)
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       rem,    0,      0,      x7,   0x20,   x6,   0x11,   x7,   0x0f)
  TEST_RR_S12(17,       rem,    0,      0,      x5,   -0x41,  x7,   0x02,   x7,   -0x01)
  TEST_RR_S12(18,       rem,    0,      0,      x7,   0x00,   x7,   0x12,   x7,   0x00)

  TEST_RR_S21(19,       rem,    0,      0,      x7,   0x30,   x7,   0x00,   x7,   0x00)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       rem,    0,      0,      x0,   0x24,   x6,   0x11,   x7,   0x00)
  TEST_RR_S12(21,       rem,    0,      0,      x5,   -0x59,  x0,   0x02,   x7,   -0x59)
  TEST_RR_S12(22,       rem,    0,      0,      x0,   0x00,   x0,   0x12,   x7,   0x00)
  TEST_RR_S12(23,       rem,    0,      0,      x5,   0x30,   x6,   0x20,   x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_BYP(24,       rem,    0,      x5,   0x2f,   x6,   0x10,   x10,  0x0f)
  TEST_RR_BYP(25,       rem,    1,      x5,   -0x20,  x6,   0x11,   x10,  -0x0f)
  TEST_RR_BYP(26,       rem,    2,      x5,   0x38,   x6,   -0x12,  x10,  0x02)
  TEST_RR_BYP(27,       rem,    4,      x5,   -0x96,  x6,   -0x14,  x10,  -0x0a)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,   rs2,  v2,     rd,   vr
  TEST_RR_S12(28,       rem,    1,      0,      x5,   0x30, x6,   0x20,   x7,   0x10)
  TEST_RR_S12(29,       rem,    1,      1,      x5,   0x30, x6,   0x21,   x7,   0x0f)

  TEST_RR_S21(30,       rem,    1,      0,      x5,   0x90, x6,   0x22,   x7,   0x08)
  TEST_RR_S21(31,       rem,    1,      1,      x5,   0x30, x6,   -0x23,  x7,   0x0d)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
