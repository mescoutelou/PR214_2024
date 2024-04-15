/*
 * File: bclr.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-05 10:21:46 am
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
  TEST_RR_S12(0,        bclr,   0,      0,      x5,   0x0000000000000000, x6,   0,    x7,   0x0000000000000000)

  TEST_RR_S12(1,        bclr,   0,      0,      x5,   0x0000000000000001, x6,   0,    x7,   0x0000000000000000)
  TEST_RR_S12(2,        bclr,   0,      0,      x5,   0x000000000000ffff, x6,   1,    x7,   0x000000000000fffd)
  TEST_RR_S12(3,        bclr,   0,      0,      x5,   0x000000000000ffff, x6,   15,   x7,   0x0000000000007fff)
  TEST_RR_S12(4,        bclr,   0,      0,      x5,   0x000000000000ffff, x6,   16,   x7,   0x000000000000ffff)
  TEST_RR_S12(5,        bclr,   0,      0,      x5,   0x000000000000ffff, x6,   31,   x7,   0x000000000000ffff)

  TEST_RR_S12(6,        bclr,   0,      0,      x5,   0xffffffffffffffff, x6,   0,    x7,   0xfffffffffffffffe)
  TEST_RR_S12(7,        bclr,   0,      0,      x5,   0xf0f0f0f0f0f0f0f0, x6,   1,    x7,   0xf0f0f0f0f0f0f0f0)
  TEST_RR_S12(8,        bclr,   0,      0,      x5,   0xf0f0f0f0f0f0f0f0, x6,   15,   x7,   0xf0f0f0f0f0f070f0)
  TEST_RR_S12(9,        bclr,   0,      0,      x5,   0xf0f0f0f0f0f0f0f0, x6,   16,   x7,   0xf0f0f0f0f0f0f0f0)
  TEST_RR_S12(10,       bclr,   0,      0,      x5,   0xf0f0f0f0f0f0f0f0, x6,   31,   x7,   0xf0f0f0f070f0f0f0)

  #if (XLEN == 64)
  TEST_RR_S12(11,       bclr,   0,      0,      x5,   0x0000000100000001, x6,   32,   x7,   0x0000000000000001)
  TEST_RR_S12(12,       bclr,   0,      0,      x10,  0x0000000100000001, x11,  50,   x12,  0x0000000100000001)
  TEST_RR_S12(13,       bclr,   0,      0,      x13,  0x0000000100000001, x14,  63,   x15,  0x0000000100000001)
  TEST_RR_S12(14,       bclr,   0,      0,      x12,  0xffffffffffffffff, x10,  32,   x11,  0xfffffffeffffffff)
  TEST_RR_S12(15,       bclr,   0,      0,      x17,  0xffffffffffffffff, x10,  63,   x13,  0x7fffffffffffffff)
  #else
  TEST_RR_S12(11,       bclr,   0,      0,      x5,   0x00000001,         x6,   32,   x7,   0x00000000)
  TEST_RR_S12(12,       bclr,   0,      0,      x10,  0x00000001,         x11,  50,   x12,  0x00000001)
  TEST_RR_S12(13,       bclr,   0,      0,      x13,  0x00000001,         x14,  63,   x15,  0x00000001)
  TEST_RR_S12(14,       bclr,   0,      0,      x12,  0xffffffff,         x10,  32,   x11,  0xfffffffe)
  TEST_RR_S12(15,       bclr,   0,      0,      x17,  0xffffffff,         x10,  63,   x13,  0x7fffffff)
  #endif
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       bclr,   0,      0,      x7,   0x20,   x6,   1,      x7,   0x20)
  TEST_RR_S12(17,       bclr,   0,      0,      x5,   0x31,   x7,   0,      x7,   0x30)
  TEST_RR_S12(18,       bclr,   0,      0,      x7,   0x22,   x7,   3,      x7,   0x03)

  TEST_RR_S21(19,       bclr,   0,      0,      x7,   0x30,   x7,   0,      x7,   0x30)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       bclr,   0,      0,      x0,   0x20,   x6,   2,      x7,   0x00)
  TEST_RR_S12(21,       bclr,   0,      0,      x5,   0x44,   x0,   2,      x7,   0x44)
  TEST_RR_S12(22,       bclr,   0,      0,      x0,   0x00,   x0,   3,      x7,   0x00)
  TEST_RR_S12(23,       bclr,   0,      0,      x5,   0x30,   x6,   1,      x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_BYP(24,       bclr,   0,      x5,   0x21,   x6,   0,      x10,  0x20)
  TEST_RR_BYP(25,       bclr,   1,      x5,   0x21,   x6,   1,      x10,  0x21)
  TEST_RR_BYP(26,       bclr,   2,      x5,   0x25,   x6,   2,      x10,  0x21)
  TEST_RR_BYP(27,       bclr,   4,      x5,   0x21,   x6,   3,      x10,  0x21)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,       rs2,  v2,   rd,   vr
  TEST_RR_S12(28,       bclr,   1,      0,      x5,   0xff33,   x6,   4,    x7,   0xff23)
  TEST_RR_S12(29,       bclr,   1,      1,      x5,   0xff33,   x6,   8,    x7,   0xfe33)

  TEST_RR_S21(30,       bclr,   1,      0,      x5,   0xff33,   x6,   12,    x7,  0xef33)
  TEST_RR_S21(31,       bclr,   1,      1,      x5,   0xff33,   x6,   12,    x7,  0xef33)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
