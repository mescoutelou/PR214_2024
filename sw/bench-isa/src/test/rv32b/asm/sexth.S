/*
 * File: sexth.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-14 11:54:16 am
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
  TEST_R( 0,        sext.h, 0,      x5,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_R( 1,        sext.h, 0,      x5,   0x0000000100000001, x7,   0x0000000000000001)
  TEST_R( 2,        sext.h, 0,      x5,   0x0000ffff0000ffff, x7,   0xffffffffffffffff)
  TEST_R( 3,        sext.h, 0,      x5,   0x7fff00007fff0000, x7,   0x0000000000000000)
  TEST_R( 4,        sext.h, 0,      x5,   0x000000007f7f7f7f, x7,   0x0000000000007f7f)
  TEST_R( 5,        sext.h, 0,      x5,   0x0000000000008000, x7,   0xffffffffffff8000)

  TEST_R( 6,        sext.h, 0,      x5,   0xaaaaaaaaaaaaaaaa, x7,   0xffffffffffffaaaa)
  TEST_R( 7,        sext.h, 0,      x5,   0x7777777777777777, x7,   0x0000000000007777)
  TEST_R( 8,        sext.h, 0,      x5,   0x0010000000100001, x7,   0x0000000000000001)
  TEST_R( 9,        sext.h, 0,      x5,   0x0001000000010011, x7,   0x0000000000000011)
  TEST_R( 10,       sext.h, 0,      x5,   0x0000100000001111, x7,   0x0000000000001111)

  TEST_R( 11,       sext.h, 0,      x5,   0x0000000000000001, x7,   0x0000000000000001)
  TEST_R( 12,       sext.h, 0,      x10,  0x0000000000007878, x11,  0x0000000000007878)
  TEST_R( 13,       sext.h, 0,      x13,  0x00000000000000ff, x14,  0x00000000000000ff)
  TEST_R( 14,       sext.h, 0,      x12,  0x0000000000000087, x10,  0x0000000000000087)
  TEST_R( 15,       sext.h, 0,      x17,  0xffffffffffff0000, x10,  0x0000000000000000)  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R( 16,       sext.h, 0,      x7,   0x000000000000777f,   x7,   0x000000000000777f)
  TEST_R( 17,       sext.h, 0,      x7,   0x0000000000008000,   x7,   0xffffffffffff8000)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R( 18,       sext.h, 0,      x0,   0x00100000001000ff,   x7,   0x0000000000000000)
  TEST_R( 19,       sext.h, 0,      x5,   0x00100000001000ff,   x0,   0x0000000000000000)
  TEST_R( 20,       sext.h, 0,      x0,   0x00100000001000ff,   x0,   0x0000000000000000)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R_BYP( 21,       sext.h, 0,      x5,   0x0000000000001111,   x7,   0x0000000000001111)
  TEST_R_BYP( 22,       sext.h, 1,      x5,   0x0000000000009191,   x7,   0xffffffffffff9191)
  TEST_R_BYP( 23,       sext.h, 2,      x5,   0x0000000000004444,   x7,   0x0000000000004444)
  TEST_R_BYP( 24,       sext.h, 4,      x5,   0x0000000000007777,   x7,   0x00000000000007777)

  //      testnum,  instr,  nnop,   rs1,  v1,                   rd,   vr)
  TEST_R( 25,       sext.h, 1,      x5,   0x000000000000a4a4,   x7,   0xffffffffffffa4a4)
  TEST_R( 26,       sext.h, 1,      x5,   0x0000000000001010,   x7,   0x0000000000001010)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
