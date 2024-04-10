/*
 * File: cpop.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-13 08:19:46 am
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
  TEST_R( 0,        cpop,   0,      x5,   0x0000000000000000, x7,   0)

  TEST_R( 1,        cpop,   0,      x5,   0x0000000000000001, x7,   1)
  TEST_R( 2,        cpop,   0,      x5,   0x000000000000ffff, x7,   16)
  TEST_R( 3,        cpop,   0,      x5,   0x000000000000ffff, x7,   16)
  TEST_R( 4,        cpop,   0,      x5,   0x0000000000000000, x7,   0)
  TEST_R( 5,        cpop,   0,      x5,   0x00000000aaa1aaaa, x7,   15)

  TEST_R( 6,        cpop,   0,      x5,   0x00000000ffffffff, x7,   32)
  TEST_R( 7,        cpop,   0,      x5,   0xf0f0f0f0f0f0f0f0, x7,   16)
  TEST_R( 8,        cpop,   0,      x5,   0xf0f0f0f0f0f0fff0, x7,   20)
  TEST_R( 9,        cpop,   0,      x5,   0xf0f0f0f0f1f0f0f0, x7,   17)
  TEST_R( 10,       cpop,   0,      x5,   0xf0f0f0f0f00000f0, x7,   8)

  #if (XLEN == 64)
  TEST_R( 11,       cpop,   0,      x5,   0x0000000100000001, x7,   2)
  TEST_R( 12,       cpop,   0,      x10,  0x4000000100000001, x11,  3)
  TEST_R( 13,       cpop,   0,      x13,  0x0030000100000001, x14,  4)
  TEST_R( 14,       cpop,   0,      x12,  0xffffffffffffffff, x10,  64)
  TEST_R( 15,       cpop,   0,      x17,  0xefffffffffffffff, x10,  63)
  #else
  TEST_R( 11,       cpop,   0,      x5,   0x10000000,         x7,   1)
  TEST_R( 12,       cpop,   0,      x10,  0x11111111,         x11,  8)
  TEST_R( 13,       cpop,   0,      x13,  0x88888888,         x14,  8)
  TEST_R( 14,       cpop,   0,      x12,  0xffffffff,         x10,  32)
  TEST_R( 15,       cpop,   0,      x17,  0xff1234ff,         x10,  21)
  #endif
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  v1,           rd,   vr)
  TEST_R( 16,       cpop,   0,      x7,   0x22222222,   x7,   8)
  TEST_R( 17,       cpop,   0,      x7,   0x00070000,   x7,   3)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  v1,           rd,   vr)
  TEST_R( 18,       cpop,   0,      x0,   0x00000000,   x7,   0)
  TEST_R( 19,       cpop,   0,      x5,   0x00000000,   x0,   0)
  TEST_R( 20,       cpop,   0,      x0,   0x00000000,   x0,   0)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,           rd,   vr)
  TEST_R_BYP( 21,       cpop,   0,      x5,   0x00000077,   x7,   6)
  TEST_R_BYP( 22,       cpop,   1,      x5,   0x00000076,   x7,   5)
  TEST_R_BYP( 23,       cpop,   2,      x5,   0x00000176,   x7,   6)
  TEST_R_BYP( 24,       cpop,   4,      x5,   0x00000476,   x7,   6)

  //      testnum,  instr,  nnop,   rs1,  v1,           rd,   vr)
  TEST_R( 25,       cpop,   1,      x5,   0x44006600,   x7,   6)
  TEST_R( 26,       cpop,   1,      x5,   0xabababab,   x7,   20)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
