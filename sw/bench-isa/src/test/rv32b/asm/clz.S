/*
 * File: clz.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-13 08:31:06 am
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
  TEST_R( 0,        clz,    0,      x5,   0x0000000000000000, x7,   64)
  #else
  TEST_R( 0,        clz,    0,      x5,   0x0000000000000000, x7,   32)
  #endif

  TEST_R( 1,        clz,    0,      x5,   0x0000000100000001, x7,   31)
  TEST_R( 2,        clz,    0,      x5,   0x0000ffff0000ffff, x7,   16)
  TEST_R( 3,        clz,    0,      x5,   0x7fff00007fff0000, x7,   1)
  TEST_R( 4,        clz,    0,      x5,   0x8000000080000000, x7,   0)
  TEST_R( 5,        clz,    0,      x5,   0x1000000010000000, x7,   3)

  TEST_R( 6,        clz,    0,      x5,   0xaaaaaaaaaaaaaaaa, x7,   0)
  TEST_R( 7,        clz,    0,      x5,   0x7777777777777777, x7,   1)
  TEST_R( 8,        clz,    0,      x5,   0x0010000000100000, x7,   11)
  TEST_R( 9,        clz,    0,      x5,   0x0001000000010000, x7,   15)
  TEST_R( 10,       clz,    0,      x5,   0x0000100000001000, x7,   19)

  #if (XLEN == 64)
  TEST_R( 11,       clz,    0,      x5,   0x0000000000000001, x7,   63)
  TEST_R( 12,       clz,    0,      x10,  0x0000000010000000, x11,  35)
  TEST_R( 13,       clz,    0,      x13,  0x00000000000000ff, x14,  56)
  TEST_R( 14,       clz,    0,      x12,  0x1000000000000000, x10,  3)
  TEST_R( 15,       clz,    0,      x17,  0x0000100000000000, x10,  19)
  #else
  TEST_R( 11,       clz,    0,      x5,   0x00000001,         x7,   31)
  TEST_R( 12,       clz,    0,      x10,  0x10000000,         x11,  3)
  TEST_R( 13,       clz,    0,      x13,  0x000000ff,         x14,  24)
  TEST_R( 14,       clz,    0,      x12,  0x10001000,         x10,  3)
  TEST_R( 15,       clz,    0,      x17,  0x00008000,         x10,  16)
  #endif
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R( 16,       clz,    0,      x7,   0x0010000000100000,   x7,   11)
  TEST_R( 17,       clz,    0,      x7,   0x0001000000010000,   x7,   15)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  #if (XLEN == 64)
  TEST_R( 18,       clz,    0,      x0,   0x0010000000100000,   x7,   64)
  #else
  TEST_R( 18,       clz,    0,      x0,   0x0010000000100000,   x7,   32)
  #endif
  TEST_R( 19,       clz,    0,      x5,   0x0010000000100000,   x0,   0)
  TEST_R( 20,       clz,    0,      x0,   0x0010000000100000,   x0,   0)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R_BYP( 21,       clz,    0,      x5,   0x8000000080000000,   x7,   0)
  TEST_R_BYP( 22,       clz,    1,      x5,   0x0800000008000000,   x7,   4)
  TEST_R_BYP( 23,       clz,    2,      x5,   0x0080000000800000,   x7,   8)
  TEST_R_BYP( 24,       clz,    4,      x5,   0x0008000000080000,   x7,   12)

  //      testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R( 25,       clz,    1,      x5,   0x0030000000300000,   x7,   10)
  TEST_R( 26,       clz,    1,      x5,   0x0050000000500000,   x7,   9)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
