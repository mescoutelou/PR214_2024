/*
 * File: rol.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-18 08:16:37 am
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
  TEST_RR_S12(0,        rol,    0,      0,      x5,   0x0000000000000000, x6,   0,    x7,   0x0000000000000000)

  TEST_RR_S12(1,        rol,    0,      0,      x5,   0x0000000100000001, x6,   0,    x7,   0x0000000100000001)
  TEST_RR_S12(2,        rol,    0,      0,      x5,   0x0000000100000001, x6,   1,    x7,   0x0000000200000002)
  TEST_RR_S12(3,        rol,    0,      0,      x5,   0x0000000100000001, x6,   15,   x7,   0x0000800000008000)
  TEST_RR_S12(4,        rol,    0,      0,      x5,   0x0000000100000001, x6,   16,   x7,   0x0001000000010000)
  TEST_RR_S12(5,        rol,    0,      0,      x5,   0x0000000100000001, x6,   31,   x7,   0x8000000080000000)

  TEST_RR_S12(6,        rol,    0,      0,      x5,   0xffffffffffffffff, x6,   0,    x7,   0xffffffffffffffff)
  TEST_RR_S12(7,        rol,    0,      0,      x5,   0xffffffffffffffff, x6,   1,    x7,   0xffffffffffffffff)
  TEST_RR_S12(8,        rol,    0,      0,      x5,   0xefffffffefffffff, x6,   16,   x7,   0xffffefffffffefff)
  TEST_RR_S12(9,        rol,    0,      0,      x5,   0xffffffffffffffff, x6,   16,   x7,   0xffffffffffffffff)
  TEST_RR_S12(10,       rol,    0,      0,      x5,   0xefffffffefffffff, x6,   31,   x7,   0xf7fffffff7ffffff)

  #if (XLEN == 64)
  TEST_RR_S12(11,       rol,    0,      0,      x5,   0x1000000000000001, x6,   32,   x7,   0x0000000110000000)
  TEST_RR_S12(12,       rol,    0,      0,      x10,  0x1000000000000001, x11,  50,   x12,  0x0004400000000000)
  TEST_RR_S12(13,       rol,    0,      0,      x13,  0x1000000000000001, x14,  63,   x15,  0x8800000000000000)
  TEST_RR_S12(14,       rol,    0,      0,      x12,  0xffffffffffffffff, x10,  32,   x11,  0xffffffffffffffff)
  TEST_RR_S12(15,       rol,    0,      0,      x17,  0xffffffffffff0000, x10,  16,   x13,  0xffffffff0000ffff)
  #else
  TEST_RR_S12(11,       rol,    0,      0,      x5,   0x10000001,         x6,   16,   x7,   0x00011000)
  TEST_RR_S12(12,       rol,    0,      0,      x10,  0x10000001,         x11,  50,   x12,  0x00044000)
  TEST_RR_S12(13,       rol,    0,      0,      x13,  0x10000001,         x14,  63,   x15,  0x88000000)
  TEST_RR_S12(14,       rol,    0,      0,      x12,  0xffffffff,         x10,  32,   x11,  0xffffffff)
  TEST_RR_S12(15,       rol,    0,      0,      x17,  0xefffffff,         x10,  63,   x13,  0xf7ffffff)
  #endif
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       rol,    0,      0,      x7,   0x20,   x6,   1,      x7,   0x000040)
  TEST_RR_S12(17,       rol,    0,      0,      x5,   0x31,   x7,   2,      x7,   0x0000c4)
  TEST_RR_S12(18,       rol,    0,      0,      x7,   0x22,   x7,   3,      x7,   0x000018)

  TEST_RR_S21(19,       rol,    0,      0,      x7,   0x30,   x7,   0,      x7,   0x300000)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       rol,    0,      0,      x0,   0x20,   x6,   2,      x7,   0x00)
  TEST_RR_S12(21,       rol,    0,      0,      x5,   0x44,   x0,   2,      x7,   0x44)
  TEST_RR_S12(22,       rol,    0,      0,      x0,   0x00,   x0,   3,      x7,   0x00)
  TEST_RR_S12(23,       rol,    0,      0,      x5,   0x30,   x6,   1,      x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_BYP(24,       rol,    0,      x5,   0x21,   x6,   0,      x10,  0x0021)
  TEST_RR_BYP(25,       rol,    1,      x5,   0x21,   x6,   1,      x10,  0x0042)
  TEST_RR_BYP(26,       rol,    2,      x5,   0x21,   x6,   2,      x10,  0x0084)
  TEST_RR_BYP(27,       rol,    4,      x5,   0x21,   x6,   3,      x10,  0x0108)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,   rd,   vr
  TEST_RR_S12(28,       rol,    1,      0,      x5,   0x01,   x6,   4,    x7,   0x0010)
  TEST_RR_S12(29,       rol,    1,      1,      x5,   0x01,   x6,   8,    x7,   0x0100)

  TEST_RR_S21(30,       rol,    1,      0,      x5,   0x01,   x6,   12,   x7,   0x1000)
  TEST_RR_S21(31,       rol,    1,      1,      x5,   0x03,   x6,   12,   x7,   0x3000)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
