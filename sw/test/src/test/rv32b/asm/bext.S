/*
 * File: bext.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-05 09:40:59 am
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
  TEST_RR_S12(0,        bext,   0,      0,      x5,   0x0000000000000000, x6,   0,    x7,   0)

  TEST_RR_S12(1,        bext,   0,      0,      x5,   0x0000000000000001, x6,   0,    x7,   1)
  TEST_RR_S12(2,        bext,   0,      0,      x5,   0x000000000000ffff, x6,   1,    x7,   1)
  TEST_RR_S12(3,        bext,   0,      0,      x5,   0x000000000000ffff, x6,   15,   x7,   1)
  TEST_RR_S12(4,        bext,   0,      0,      x5,   0x0000000000000000, x6,   16,   x7,   0)
  TEST_RR_S12(5,        bext,   0,      0,      x5,   0x0000000000000000, x6,   31,   x7,   0)

  TEST_RR_S12(6,        bext,   0,      0,      x5,   0xffffffffffffffff, x6,   0,    x7,   1)
  TEST_RR_S12(7,        bext,   0,      0,      x5,   0xf0f0f0f0f0f0f0f0, x6,   1,    x7,   0)
  TEST_RR_S12(8,        bext,   0,      0,      x5,   0xf0f0f0f0f0f0f0f0, x6,   15,   x7,   1)
  TEST_RR_S12(9,        bext,   0,      0,      x5,   0xf0f0f0f0f0f0f0f0, x6,   16,   x7,   0)
  TEST_RR_S12(10,       bext,   0,      0,      x5,   0xf0f0f0f0f0f0f0f0, x6,   31,   x7,   1)

  #if (XLEN == 64)
  TEST_RR_S12(11,       bext,   0,      0,      x5,   0x0000000100000001, x6,   32,   x7,   1)
  TEST_RR_S12(12,       bext,   0,      0,      x10,  0x0000000100000001, x11,  50,   x12,  0)
  TEST_RR_S12(13,       bext,   0,      0,      x13,  0x0000000100000001, x14,  63,   x15,  0)
  TEST_RR_S12(14,       bext,   0,      0,      x12,  0xffffffffffffffff, x10,  32,   x11,  1)
  TEST_RR_S12(15,       bext,   0,      0,      x17,  0xffffffffffffffff, x10,  63,   x13,  1)
  #else
  TEST_RR_S12(11,       bext,   0,      0,      x5,   0x00000001,         x6,   32,   x7,   1)
  TEST_RR_S12(12,       bext,   0,      0,      x10,  0x00000001,         x11,  50,   x12,  0)
  TEST_RR_S12(13,       bext,   0,      0,      x13,  0x00000001,         x14,  63,   x15,  0)
  TEST_RR_S12(14,       bext,   0,      0,      x12,  0xffffffff,         x10,  32,   x11,  1)
  TEST_RR_S12(15,       bext,   0,      0,      x17,  0xffffffff,         x10,  63,   x13,  1)
  #endif
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       bext,   0,      0,      x7,   0x20,   x6,   1,      x7,   0)
  TEST_RR_S12(17,       bext,   0,      0,      x5,   0x31,   x7,   0,      x7,   1)
  TEST_RR_S12(18,       bext,   0,      0,      x7,   0x22,   x7,   3,      x7,   0)

  TEST_RR_S21(19,       bext,   0,      0,      x7,   0x30,   x7,   0,      x7,   0)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       bext,   0,      0,      x0,   0x20,   x6,   2,      x7,   0)
  TEST_RR_S12(21,       bext,   0,      0,      x5,   0x45,   x0,   2,      x7,   1)
  TEST_RR_S12(22,       bext,   0,      0,      x0,   0x00,   x0,   3,      x7,   0)
  TEST_RR_S12(23,       bext,   0,      0,      x5,   0x30,   x6,   1,      x0,   0)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_BYP(24,       bext,   0,      x5,   0x21,   x6,   0,      x10,  1)
  TEST_RR_BYP(25,       bext,   1,      x5,   0x21,   x6,   1,      x10,  0)
  TEST_RR_BYP(26,       bext,   2,      x5,   0x25,   x6,   2,      x10,  1)
  TEST_RR_BYP(27,       bext,   4,      x5,   0x21,   x6,   3,      x10,  0)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,       rs2,  v2,   rd,   vr
  TEST_RR_S12(28,       bext,   1,      0,      x5,   0xff33,   x6,   4,    x7,   1)
  TEST_RR_S12(29,       bext,   1,      1,      x5,   0xff33,   x6,   8,    x7,   1)

  TEST_RR_S21(30,       bext,   1,      0,      x5,   0xff33,   x6,   12,    x7,  1)
  TEST_RR_S21(31,       bext,   1,      1,      x5,   0x0f33,   x6,   12,    x7,  0)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
