/*
 * File: max.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-05 03:20:23 pm
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
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                 rs2,  v2,                 rd,   vr
  TEST_RR_S12(0,        max,    0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(1,        max,    0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000002, x7,   0x0000000000000002)
  TEST_RR_S12(2,        max,    0,      0,      x5,   0x0000000000000009, x6,   0x0000000000000008, x7,   0x0000000000000009)

  TEST_RR_S12(3,        max,    0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(4,        max,    0,      0,      x5,   0xffff0000ffff0000, x6,   0x0000ffff0000ffff, x7,   0x0000ffff0000ffff)
  TEST_RR_S12(5,        max,    0,      0,      x5,   0x0000ffff0000ffff, x6,   0xffff0000ffff0000, x7,   0x0000ffff0000ffff)

  TEST_RR_S12(6,        max,    0,      0,      x5,   0x000f000f000f000f, x6,   0xffffffffffffffff, x7,   0x000f000f000f000f)
  TEST_RR_S12(7,        max,    0,      0,      x5,   0x8000000080000000, x6,   0x7000000070000000, x7,   0x7000000070000000)
  TEST_RR_S12(8,        max,    0,      0,      x5,   0xffff0000ffff0000, x6,   0xffffffffffffffff, x7,   0xffffffffffffffff)

  TEST_RR_S12(9,        max,    0,      0,      x5,   0x0000ffff0000ffff, x6,   0x0000ffff0000ffff, x7,   0x0000ffff0000ffff)
  TEST_RR_S12(10,       max,    0,      0,      x5,   0x8000000080000000, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(11,       max,    0,      0,      x5,   0xa5a5a5a5a5a5a5a5, x6,   0x5a5a5a5a5a5a5a5a, x7,   0x5a5a5a5a5a5a5a5a)

  TEST_RR_S12(12,       max,    0,      0,      x10,  0xc6c6c6c6c6c6c6c6, x11,  0x6c6c6c6c6c6c6c6c, x12,  0x6c6c6c6c6c6c6c6c)
  TEST_RR_S12(13,       max,    0,      0,      x13,  0xc6c6c6c6c6c6c6c6, x14,  0xc6c6c6c6c6c6c6c6, x15,  0xc6c6c6c6c6c6c6c6)
  TEST_RR_S12(14,       max,    0,      0,      x12,  0x0000111100001111, x10,  0x1010101010101010, x11,  0x1010101010101010)
  TEST_RR_S12(15,       max,    0,      0,      x17,  0xffffffffffffffff, x10,  0xffffffffffffffff, x13,  0xffffffffffffffff)
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       max,    0,      0,      x7,   0x20,   x6,   0x11,   x7,   0x20)
  TEST_RR_S12(17,       max,    0,      0,      x5,   0x01,   x7,   0x02,   x7,   0x02)
  TEST_RR_S12(18,       max,    0,      0,      x7,   0x00,   x7,   0x12,   x7,   0x12)

  TEST_RR_S21(19,       max,    0,      0,      x7,   0x30,   x7,   0x00,   x7,   0x30)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       max,    0,      0,      x0,   0x20,   x6,   0x11,   x7,   0x11)
  TEST_RR_S12(21,       max,    0,      0,      x5,   -0x44,  x0,   0x02,   x7,   0x00)
  TEST_RR_S12(22,       max,    0,      0,      x0,   0x00,   x0,   0x12,   x7,   0x00)
  TEST_RR_S12(23,       max,    0,      0,      x5,   0x30,   x6,   0x20,   x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_BYP(24,       max,    0,      x5,   0x20,   x6,   0x10,   x10,  0x20)
  TEST_RR_BYP(25,       max,    1,      x5,   0x20,   x6,   0x30,   x10,  0x30)
  TEST_RR_BYP(26,       max,    2,      x5,   0x20,   x6,   0x1f,   x10,  0x20)
  TEST_RR_BYP(27,       max,    4,      x5,   -0x20,  x6,   -0x14,  x10,  -0x14)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,   rd,   vr
  TEST_RR_S12(28,       max,    1,      0,      x5,   0x30,   x6,   0x20, x7,   0x30)
  TEST_RR_S12(29,       max,    1,      1,      x5,   0x30,   x6,   0x31, x7,   0x31)

  TEST_RR_S21(30,       max,    1,      0,      x5,   0x30,   x6,   0x32, x7,   0x32)
  TEST_RR_S21(31,       max,    1,      1,      x5,   -0x30,  x6,   0x23, x7,   0x23)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
