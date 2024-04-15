/*
 * File: sextb.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-14 11:26:08 am
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
  TEST_R( 0,        sext.b, 0,      x5,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_R( 1,        sext.b, 0,      x5,   0x0000000100000001, x7,   0x0000000000000001)
  TEST_R( 2,        sext.b, 0,      x5,   0x0000ffff0000ffff, x7,   0xffffffffffffffff)
  TEST_R( 3,        sext.b, 0,      x5,   0x7fff00007fff0000, x7,   0x0000000000000000)
  TEST_R( 4,        sext.b, 0,      x5,   0x000000007f7f7f7f, x7,   0x000000000000007f)
  TEST_R( 5,        sext.b, 0,      x5,   0x0000000000000080, x7,   0xffffffffffffff80)

  TEST_R( 6,        sext.b, 0,      x5,   0xaaaaaaaaaaaaaaaa, x7,   0xffffffffffffffaa)
  TEST_R( 7,        sext.b, 0,      x5,   0x7777777777777777, x7,   0x0000000000000077)
  TEST_R( 8,        sext.b, 0,      x5,   0x0010000000100001, x7,   0x0000000000000001)
  TEST_R( 9,        sext.b, 0,      x5,   0x0001000000010011, x7,   0x0000000000000011)
  TEST_R( 10,       sext.b, 0,      x5,   0x0000100000001111, x7,   0x0000000000000011)

  TEST_R( 11,       sext.b, 0,      x5,   0x0000000000000001, x7,   0x0000000000000001)
  TEST_R( 12,       sext.b, 0,      x10,  0x0000000000000078, x11,  0x0000000000000078)
  TEST_R( 13,       sext.b, 0,      x13,  0x00000000000000ff, x14,  0xffffffffffffffff)
  TEST_R( 14,       sext.b, 0,      x12,  0x0000000000000087, x10,  0xffffffffffffff87)
  TEST_R( 15,       sext.b, 0,      x17,  0xffffffffffffff00, x10,  0x0000000000000000)  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R( 16,       sext.b, 0,      x7,   0x000000000000007f,   x7,   0x000000000000007f)
  TEST_R( 17,       sext.b, 0,      x7,   0x0000000000000080,   x7,   0xffffffffffffff80)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R( 18,       sext.b, 0,      x0,   0x00100000001000ff,   x7,   0x0000000000000000)
  TEST_R( 19,       sext.b, 0,      x5,   0x00100000001000ff,   x0,   0x0000000000000000)
  TEST_R( 20,       sext.b, 0,      x0,   0x00100000001000ff,   x0,   0x0000000000000000)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R_BYP( 21,       sext.b, 0,      x5,   0x0000000000000011,   x7,   0x0000000000000011)
  TEST_R_BYP( 22,       sext.b, 1,      x5,   0x0000000000000091,   x7,   0xffffffffffffff91)
  TEST_R_BYP( 23,       sext.b, 2,      x5,   0x0000000000000044,   x7,   0x0000000000000044)
  TEST_R_BYP( 24,       sext.b, 4,      x5,   0x0000000000000077,   x7,   0x00000000000000077)

  //      testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R( 25,       sext.b, 1,      x5,   0x00000000000000a4,   x7,   0xffffffffffffffa4)
  TEST_R( 26,       sext.b, 1,      x5,   0x0000000000000010,   x7,   0x0000000000000010)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
