/*
 * File: srl.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-18 08:17:00 am
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
  TEST_RR_S12(0,        srl,    0,      0,      x5,   0x0000000000000000, x6,   0,    x7,   0x0000000000000000)

  TEST_RR_S12(1,        srl,    0,      0,      x5,   0x8000000080000000, x6,   0,    x7,   0x8000000080000000)
  TEST_RR_S12(2,        srl,    0,      0,      x5,   0x8000000080000000, x6,   1,    x7,   0x4000000040000000)
  TEST_RR_S12(3,        srl,    0,      0,      x5,   0x8000000080000000, x6,   15,   x7,   0x0001000000010000)
  TEST_RR_S12(4,        srl,    0,      0,      x5,   0x8000000080000000, x6,   16,   x7,   0x0000800000008000)
  TEST_RR_S12(5,        srl,    0,      0,      x5,   0x8000000080000000, x6,   31,   x7,   0x0000000100000001)

  TEST_RR_S12(6,        srl,    0,      0,      x5,   0x4000000040000000, x6,   0,    x7,   0x4000000040000000)
  TEST_RR_S12(7,        srl,    0,      0,      x5,   0x4000000040000000, x6,   1,    x7,   0x2000000020000000)
  TEST_RR_S12(8,        srl,    0,      0,      x5,   0x4000000040000000, x6,   15,   x7,   0x0000800000008000)
  TEST_RR_S12(9,        srl,    0,      0,      x5,   0x4000000040000000, x6,   16,   x7,   0x0000400000004000)
  #if (XLEN == 64)
  TEST_RR_S12(10,       srl,    0,      0,      x5,   0x4000000040000000, x6,   31,   x7,   0x0000000080000000)
  #else
  TEST_RR_S12(10,       srl,    0,      0,      x5,   0x40000000,         x6,   31,   x7,   0x00000000)
  #endif

  #if (XLEN == 64)
  TEST_RR_S12(11,       srl,    0,      0,      x5,   0x8000000000000000, x6,   32,    x7,  0x0000000080000000)
  TEST_RR_S12(12,       srl,    0,      0,      x10,  0x8000000000000000, x11,  50,    x12, 0x0000000000002000)
  TEST_RR_S12(13,       srl,    0,      0,      x13,  0x8000000000000000, x14,  63,    x15, 0x0000000000000001)
  TEST_RR_S12(14,       srl,    0,      0,      x12,  0xffffffffffffffff, x10,  32,    x11, 0x00000000ffffffff)
  TEST_RR_S12(15,       srl,    0,      0,      x17,  0xffffffffffffffff, x10,  63,    x13, 0x0000000000000001)
  #else
  TEST_RR_S12(11,       srl,    0,      0,      x5,   0x80000000,         x6,   32,    x7,  0x80000000)
  TEST_RR_S12(12,       srl,    0,      0,      x10,  0x80000000,         x11,  50,    x12, 0x00002000)
  TEST_RR_S12(13,       srl,    0,      0,      x13,  0x80000000,         x14,  63,    x15, 0x00000001)
  TEST_RR_S12(14,       srl,    0,      0,      x12,  0xffffffff,         x10,  32,    x11, 0xffffffff)
  TEST_RR_S12(15,       srl,    0,      0,      x17,  0xffffffff,         x10,  63,    x13, 0x00000001)
  #endif
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       srl,    0,      0,      x7,   0x20,   x6,   1,      x7,   0x10)
  TEST_RR_S12(17,       srl,    0,      0,      x5,   0x31,   x7,   2,      x7,   0x0c)
  TEST_RR_S12(18,       srl,    0,      0,      x7,   0x22,   x7,   3,      x7,   0x00)

  TEST_RR_S21(19,       srl,    0,      0,      x7,   0x30,   x7,   0,      x7,   0x00)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       srl,    0,      0,      x0,   0x20,   x6,   2,      x7,   0x00)
  TEST_RR_S12(21,       srl,    0,      0,      x5,   0x44,   x0,   2,      x7,   0x44)
  TEST_RR_S12(22,       srl,    0,      0,      x0,   0x00,   x0,   3,      x7,   0x00)
  TEST_RR_S12(23,       srl,    0,      0,      x5,   0x30,   x6,   1,      x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_BYP(24,       srl,    0,      x5,   0x48,   x6,   0,      x10,  0x48)
  TEST_RR_BYP(25,       srl,    1,      x5,   0x48,   x6,   1,      x10,  0x24)
  TEST_RR_BYP(26,       srl,    2,      x5,   0x48,   x6,   2,      x10,  0x12)
  TEST_RR_BYP(27,       srl,    4,      x5,   0x48,   x6,   3,      x10,  0x09)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,       rs2,  v2,   rd,   vr
  TEST_RR_S12(28,       srl,    1,      0,      x5,   0x3010,   x6,   4,    x7,   0x0301)
  TEST_RR_S12(29,       srl,    1,      1,      x5,   0x3010,   x6,   8,    x7,   0x0030)

  TEST_RR_S21(30,       srl,    1,      0,      x5,   0x3010,   x6,   12,   x7,   0x0003)
  TEST_RR_S21(31,       srl,    1,      1,      x5,   0x9010,   x6,   12,   x7,   0x0009)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
