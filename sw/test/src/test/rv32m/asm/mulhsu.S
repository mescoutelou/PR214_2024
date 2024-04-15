/*
 * File: mulhsu.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:33:11 am
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
  //           ARITHMETIC
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                 rs2,  v2,                 rd,   vr
  TEST_RR_S12(0,        mulhsu, 0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(1,        mulhsu, 0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000001, x7,   0x0000000000000000)
  #if (XLEN == 64)
  TEST_RR_S12(2,        mulhsu, 0,      0,      x5,   0x8000000000000000, x6,   0x8000000000000000, x7,   0xc000000000000000)
  #else
  TEST_RR_S12(2,        mulhsu, 0,      0,      x5,   0x80000000,         x6,   0x80000000,         x7,   0xc0000000)
  #endif

  TEST_RR_S12(3,        mulhsu, 0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000000, x7,   0x0000000000000000)
  #if (XLEN == 64)
  TEST_RR_S12(4,        mulhsu, 0,      0,      x5,   0x8000000000000000, x6,   0x4000000000000000, x7,   0xe000000000000000)
  #else
  TEST_RR_S12(4,        mulhsu, 0,      0,      x5,   0x80000000,         x6,   0x40000000,         x7,   0xe0000000)
  #endif
  TEST_RR_S12(5,        mulhsu, 0,      0,      x5,   0x0000000000000000, x6,   0xffffffffffffffff, x7,   0x0000000000000000)

  TEST_RR_S12(6,        mulhsu, 0,      0,      x5,   0x0000000000000001, x6,   0xffffffffffffffff, x7,   0x0000000000000000)
  TEST_RR_S12(7,        mulhsu, 0,      0,      x5,   0x7654321076543210, x6,   0x0000000000000001, x7,   0x0000000000000000)
  #if (XLEN == 64)
  TEST_RR_S12(8,        mulhsu, 0,      0,      x5,   0x000000000000ffff, x6,   0xffffffffffff0001, x7,   0x0000fffeffffffff)
  #else
  TEST_RR_S12(8,        mulhsu, 0,      0,      x5,   0x0000ffff,         x6,   0xffff0001,         x7,   0x0000fffe)
  #endif

  TEST_RR_S12(9,        mulhsu, 0,      0,      x5,   0x7aaaaaaa7aaaaaaa, x6,   0x0000000000001234, x7,   0x00000000000008b8)
  TEST_RR_S12(10,       mulhsu, 0,      0,      x5,   0xffff0000ffff0000, x6,   0x0000000000000001, x7,   0xffffffffffffffff)

  #if (XLEN == 64)
  TEST_RR_S12(11,       mulhsu, 0,      0,      x5,   0x8000000005000000, x6,   0x0000000004000000, x7,   0xfffffffffffffe00)
  #else
  TEST_RR_S12(11,       mulhsu, 0,      0,      x5,   0x80000500,         x6,   0x00000400,         x7,   0xfffffe00)
  #endif

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                   rs2,  v2,                     rd,   vr
  TEST_RR_S12(12,       mulhsu, 0,      0,      x10,  0x0001 << (XLEN / 2), x11,  0x7fff << (XLEN / 2),   x12,  0x7fff)
  TEST_RR_S12(13,       mulhsu, 0,      0,      x13,  0x0002 << (XLEN / 2), x14,  0x0002 << (XLEN / 2),   x15,  0x0004)
  TEST_RR_S12(14,       mulhsu, 0,      0,      x12,  0x0010 << (XLEN / 2), x10,  0x0100 << (XLEN / 2),   x11,  0x1000)
  TEST_RR_S12(15,       mulhsu, 0,      0,      x17,  -0x0008 << (XLEN / 2), x10, 0x1111 << (XLEN / 2),   x13,  -0x8888)
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                   rs2,  v2,                   rd,   vr
  TEST_RR_S12(16,       mulhsu, 0,      0,      x7,   0x20 << (XLEN / 2),   x6,   0x11 << (XLEN / 2),   x7,   0x0220)
  TEST_RR_S12(17,       mulhsu, 0,      0,      x5,   -0x44 << (XLEN / 2),  x7,   0x02 << (XLEN / 2),   x7,   -0x0088)
  TEST_RR_S12(18,       mulhsu, 0,      0,      x7,   0x00 << (XLEN / 2),   x7,   0x12 << (XLEN / 2),   x7,   0x0144)

  TEST_RR_S21(19,       mulhsu, 0,      0,      x7,   0x30 << (XLEN / 2),   x7,   0x00 << (XLEN / 2),   x7,   0x0900)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                   rs2,  v2,                   rd,   vr
  TEST_RR_S12(20,       mulhsu, 0,      0,      x0,   0x20 << (XLEN / 2),   x6,   0x11 << (XLEN / 2),   x7,   0x00)
  TEST_RR_S12(21,       mulhsu, 0,      0,      x5,   -0x44 << (XLEN / 2),  x0,   0x02 << (XLEN / 2),   x7,   0x00)
  TEST_RR_S12(22,       mulhsu, 0,      0,      x0,   0x00 << (XLEN / 2),   x0,   0x12 << (XLEN / 2),   x7,   0x00)
  TEST_RR_S12(23,       mulhsu, 0,      0,      x5,   0x30 << (XLEN / 2),   x6,   0x20 << (XLEN / 2),   x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,                   rs2,  v2,                   rd,   vr
  TEST_RR_BYP(24,       mulhsu, 0,      x5,   0x20 << (XLEN / 2),   x6,   0x10 << (XLEN / 2),   x10,  0x0200)
  TEST_RR_BYP(25,       mulhsu, 1,      x5,   -0x20 << (XLEN / 2),  x6,   0x11 << (XLEN / 2),   x10,  -0x0220)
  TEST_RR_BYP(26,       mulhsu, 2,      x5,   0x20 << (XLEN / 2),   x6,   0x12 << (XLEN / 2),   x10,  0x0240)
  TEST_RR_BYP(27,       mulhsu, 4,      x5,   -0x20 << (XLEN / 2),  x6,   0x14 << (XLEN / 2),   x10,  -0x0280)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                 rs2,  v2,                   rd,   vr
  TEST_RR_S12(28,       mulhsu, 1,      0,      x5,   0x30 << (XLEN / 2), x6,   0x20 << (XLEN / 2),   x7,   0x0600)
  TEST_RR_S12(29,       mulhsu, 1,      1,      x5,   0x30 << (XLEN / 2), x6,   0x21 << (XLEN / 2),   x7,   0x0630)

  TEST_RR_S21(30,       mulhsu, 1,      0,      x5,   0x30 << (XLEN / 2), x6,   0x22 << (XLEN / 2),   x7,   0x0660)
  TEST_RR_S21(31,       mulhsu, 1,      1,      x5,   0x30 << (XLEN / 2), x6,   0x23 << (XLEN / 2),   x7,   0x0690)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
