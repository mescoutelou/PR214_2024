/*
 * File: ror.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-18 08:16:41 am
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
  TEST_RR_S12(0,        ror,    0,      0,      x5,   0x0000000000000000, x6,   0,    x7,   0x0000000000000000)

  TEST_RR_S12(1,        ror,    0,      0,      x5,   0x0000000100000001, x6,   0,    x7,   0x0000000100000001)
  TEST_RR_S12(2,        ror,    0,      0,      x5,   0x0000000100000001, x6,   1,    x7,   0x8000000080000000)
  TEST_RR_S12(3,        ror,    0,      0,      x5,   0x0000000100000001, x6,   15,   x7,   0x0002000000020000)
  TEST_RR_S12(4,        ror,    0,      0,      x5,   0x0000000100000001, x6,   16,   x7,   0x0001000000010000)
  TEST_RR_S12(5,        ror,    0,      0,      x5,   0x0000000100000001, x6,   31,   x7,   0x0000000200000002)

  TEST_RR_S12(6,        ror,    0,      0,      x5,   0xffffffffffffffff, x6,   0,    x7,   0xffffffffffffffff)
  TEST_RR_S12(7,        ror,    0,      0,      x5,   0xffffffffffffffff, x6,   1,    x7,   0xffffffffffffffff)
  TEST_RR_S12(8,        ror,    0,      0,      x5,   0xefffffffefffffff, x6,   16,   x7,   0xffffefffffffefff)
  TEST_RR_S12(9,        ror,    0,      0,      x5,   0xffffffffffffffff, x6,   16,   x7,   0xffffffffffffffff)
  TEST_RR_S12(10,       ror,    0,      0,      x5,   0xefffffffefffffff, x6,   31,   x7,   0xdfffffffdfffffff)

  #if (XLEN == 64)
  TEST_RR_S12(11,       ror,    0,      0,      x5,   0x1000000000000001, x6,   32,   x7,   0x0000000110000000)
  TEST_RR_S12(12,       ror,    0,      0,      x10,  0x1000000000000001, x11,  50,   x12,  0x0000000000004400)
  TEST_RR_S12(13,       ror,    0,      0,      x13,  0x1000000000000001, x14,  63,   x15,  0x0000000000000022)
  TEST_RR_S12(14,       ror,    0,      0,      x12,  0xffffffffffffffff, x10,  32,   x11,  0xffffffffffffffff)
  TEST_RR_S12(15,       ror,    0,      0,      x17,  0xffffffffffff0000, x10,  16,   x13,  0x0000ffffffffffff)
  #else
  TEST_RR_S12(11,       ror,    0,      0,      x5,   0x10000001,         x6,   16,   x7,   0x00011000)
  TEST_RR_S12(12,       ror,    0,      0,      x10,  0x10000001,         x11,  50,   x12,  0x00004400)
  TEST_RR_S12(13,       ror,    0,      0,      x13,  0x10000001,         x14,  63,   x15,  0x20000002)
  TEST_RR_S12(14,       ror,    0,      0,      x12,  0xffffffff,         x10,  32,   x11,  0xffffffff)
  TEST_RR_S12(15,       ror,    0,      0,      x17,  0xefffffff,         x10,  63,   x13,  0xdfffffff)
  #endif
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       ror,    0,      0,      x7,   0x20,   x6,   1,      x7,   0x000010)
  TEST_RR_S12(17,       ror,    0,      0,      x5,   0xc4,   x7,   2,      x7,   0x000031)
  #if (XLEN == 64)
  TEST_RR_S12(18,       ror,    0,      0,      x7,   0x22,   x7,   3,      x7,   0x6000000000000000)
  TEST_RR_S21(19,       ror,    0,      0,      x7,   0x30,   x7,   0,      x7,   0x0000000000300000)
  #else
  TEST_RR_S12(18,       ror,    0,      0,      x7,   0x22,   x7,   3,      x7,   0x60000000)
  TEST_RR_S21(19,       ror,    0,      0,      x7,   0x30,   x7,   0,      x7,   0x00300000)
  #endif

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       ror,    0,      0,      x0,   0x20,   x6,   2,      x7,   0x00)
  TEST_RR_S12(21,       ror,    0,      0,      x5,   0x44,   x0,   2,      x7,   0x44)
  TEST_RR_S12(22,       ror,    0,      0,      x0,   0x00,   x0,   3,      x7,   0x00)
  TEST_RR_S12(23,       ror,    0,      0,      x5,   0x30,   x6,   1,      x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_BYP(24,       ror,    0,      x5,   0x108,  x6,   0,      x10,  0x0108)
  TEST_RR_BYP(25,       ror,    1,      x5,   0x108,  x6,   1,      x10,  0x0084)
  TEST_RR_BYP(26,       ror,    2,      x5,   0x108,  x6,   2,      x10,  0x0042)
  TEST_RR_BYP(27,       ror,    4,      x5,   0x108,  x6,   3,      x10,  0x0021)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,   rd,   vr
  TEST_RR_S12(28,       ror,    1,      0,      x5,   0x1000, x6,   4,    x7,   0x0100)
  TEST_RR_S12(29,       ror,    1,      1,      x5,   0x1000, x6,   8,    x7,   0x0010)

  TEST_RR_S21(30,       ror,    1,      0,      x5,   0x1000, x6,   12,   x7,   0x0001)
  TEST_RR_S21(31,       ror,    1,      1,      x5,   0x3000, x6,   12,   x7,   0x0003)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
