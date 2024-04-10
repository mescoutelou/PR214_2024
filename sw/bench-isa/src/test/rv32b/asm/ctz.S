/*
 * File: ctz.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-14 11:50:46 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "../../../common/macro.h"
#include "../../../common/macro-r.h"


// ******************************
//            INIT
// ******************************
TEST_INIT(27)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //             LOGIC
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  v1,                 rd,   vr)
  #if (XLEN == 64)
  TEST_R( 0,        ctz,    0,      x5,   0x0000000000000000, x7,   64)
  #else
  TEST_R( 0,        ctz,    0,      x5,   0x0000000000000000, x7,   32)
  #endif

  TEST_R( 1,        ctz,    0,      x5,   0x0000000080000000, x7,   31)
  TEST_R( 2,        ctz,    0,      x5,   0x0000ffffffff0000, x7,   16)
  TEST_R( 3,        ctz,    0,      x5,   0x00000000fffffffe, x7,   1)
  TEST_R( 4,        ctz,    0,      x5,   0x0000000000000001, x7,   0)
  TEST_R( 5,        ctz,    0,      x5,   0x0000000000000008, x7,   3)

  TEST_R( 6,        ctz,    0,      x5,   0xaaaaaaaaaaaaaaaa, x7,   1)
  TEST_R( 7,        ctz,    0,      x5,   0x7777777777777777, x7,   0)
  TEST_R( 8,        ctz,    0,      x5,   0x0010000000100000, x7,   20)
  TEST_R( 9,        ctz,    0,      x5,   0x0001000000010000, x7,   16)
  TEST_R( 10,       ctz,    0,      x5,   0x0000100000001000, x7,   12)

  #if (XLEN == 64)
  TEST_R( 11,       ctz,    0,      x5,   0x8000000000000000, x7,   63)
  TEST_R( 12,       ctz,    0,      x10,  0x0000000080000000, x11,  35)
  TEST_R( 13,       ctz,    0,      x13,  0xff00000000000000, x14,  56)
  TEST_R( 14,       ctz,    0,      x12,  0x0f00000000000008, x10,  3)
  TEST_R( 15,       ctz,    0,      x17,  0x0000000000080000, x10,  19)
  #else
  TEST_R( 11,       ctz,    0,      x5,   0x00000001,         x7,   0)
  TEST_R( 12,       ctz,    0,      x10,  0x10000000,         x11,  28)
  TEST_R( 13,       ctz,    0,      x13,  0x000000ff,         x14,  0)
  TEST_R( 14,       ctz,    0,      x12,  0x10001000,         x10,  12)
  TEST_R( 15,       ctz,    0,      x17,  0x00008000,         x10,  15)
  #endif
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R( 16,       ctz,    0,      x7,   0x0010000000100000,   x7,   20)
  TEST_R( 17,       ctz,    0,      x7,   0x0001000000010000,   x7,   16)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  #if (XLEN == 64)
  TEST_R( 18,       ctz,    0,      x0,   0x0010000000100000,   x7,   64)
  #else
  TEST_R( 18,       ctz,    0,      x0,   0x0010000000100000,   x7,   32)
  #endif
  TEST_R( 19,       ctz,    0,      x5,   0x0010000000100000,   x0,   0)
  TEST_R( 20,       ctz,    0,      x0,   0x0010000000100000,   x0,   0)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R_BYP( 21,       ctz,    0,      x5,   0x0000000000010000,   x7,   16)
  TEST_R_BYP( 22,       ctz,    1,      x5,   0x0000000000100000,   x7,   20)
  TEST_R_BYP( 23,       ctz,    2,      x5,   0x0000000001000000,   x7,   24)
  TEST_R_BYP( 24,       ctz,    4,      x5,   0x0000000010000000,   x7,   28)

  //      testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R( 25,       ctz,    1,      x5,   0x0000000000300000,   x7,   20)
  TEST_R( 26,       ctz,    1,      x5,   0x0000000000400000,   x7,   22)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
