/*
 * File: orcb.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-18 08:39:27 am
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
  TEST_R( 0,        orc.b,  0,      x5,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_R( 1,        orc.b,  0,      x5,   0x0000000100000001, x7,   0x000000ff000000ff)
  TEST_R( 2,        orc.b,  0,      x5,   0x0000ffff0000ffff, x7,   0x0000ffff0000ffff)
  TEST_R( 3,        orc.b,  0,      x5,   0x7fff00007fff0000, x7,   0xffff0000ffff0000)
  TEST_R( 4,        orc.b,  0,      x5,   0x8000000080000000, x7,   0xff000000ff000000)
  TEST_R( 5,        orc.b,  0,      x5,   0x1000100010001000, x7,   0xff00ff00ff00ff00)

  TEST_R( 6,        orc.b,  0,      x5,   0xaaaaaaaaaaaaaaaa, x7,   0xffffffffffffffff)
  TEST_R( 7,        orc.b,  0,      x5,   0x7777777777777777, x7,   0xffffffffffffffff)
  TEST_R( 8,        orc.b,  0,      x5,   0x0010000000100000, x7,   0x00ff000000ff0000)
  TEST_R( 9,        orc.b,  0,      x5,   0x0001000000010000, x7,   0x00ff000000ff0000)
  TEST_R( 10,       orc.b,  0,      x5,   0x0000100000001000, x7,   0x0000ff000000ff00)

  #if (XLEN == 64)
  TEST_R( 11,       orc.b,  0,      x5,   0x0000000000000001, x7,   0x00000000000000ff)
  TEST_R( 12,       orc.b,  0,      x10,  0x0000000010000000, x11,  0x00000000ff000000)
  TEST_R( 13,       orc.b,  0,      x13,  0x00000000000000ff, x14,  0x00000000000000ff)
  TEST_R( 14,       orc.b,  0,      x12,  0x1000000000000000, x10,  0xff00000000000000)
  TEST_R( 15,       orc.b,  0,      x17,  0x0000100000000000, x10,  0x0000ff0000000000)
  #else
  TEST_R( 11,       orc.b,  0,      x5,   0x00000001,         x7,   0x000000ff)
  TEST_R( 12,       orc.b,  0,      x10,  0x10000000,         x11,  0xff000000)
  TEST_R( 13,       orc.b,  0,      x13,  0x000000ff,         x14,  0x000000ff)
  TEST_R( 14,       orc.b,  0,      x12,  0x10001000,         x10,  0xff00ff00)
  TEST_R( 15,       orc.b,  0,      x17,  0x00008000,         x10,  0x0000ff00)
  #endif  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R( 16,       orc.b,  0,      x7,   0x0010000000100000,   x7,   0x00ff000000ff0000)
  TEST_R( 17,       orc.b,  0,      x7,   0x0001000000010000,   x7,   0x00ff000000ff0000)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R( 18,       orc.b,  0,      x0,   0x0010000000100000,   x7,   0x0000000000000000)
  TEST_R( 19,       orc.b,  0,      x5,   0x0010000000100000,   x0,   0x0000000000000000)
  TEST_R( 20,       orc.b,  0,      x0,   0x0010000000100000,   x0,   0x0000000000000000)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R_BYP( 21,       orc.b,  0,      x5,   0x8000000080000000,   x7,   0xff000000ff000000)
  TEST_R_BYP( 22,       orc.b,  1,      x5,   0x0800000008000000,   x7,   0xff000000ff000000)
  TEST_R_BYP( 23,       orc.b,  2,      x5,   0x0080000000800000,   x7,   0x00ff000000ff0000)
  TEST_R_BYP( 24,       orc.b,  4,      x5,   0x0008000000080000,   x7,   0x00ff000000ff0000)

  //      testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R( 25,       orc.b,  1,      x5,   0x0030000000300000,   x7,   0x00ff000000ff0000)
  TEST_R( 26,       orc.b,  1,      x5,   0x0000500000000050,   x7,   0x0000ff00000000ff)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
