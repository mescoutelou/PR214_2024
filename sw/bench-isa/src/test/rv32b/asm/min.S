/*
 * File: min.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-09 08:43:21 am
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
  TEST_RR_S12(0,        min,    0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(1,        min,    0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000002, x7,   0x0000000000000001)
  TEST_RR_S12(2,        min,    0,      0,      x5,   0x0000000000000009, x6,   0x0000000000000008, x7,   0x0000000000000008)

  TEST_RR_S12(3,        min,    0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000000, x7,   0xffffffffffffffff)
  TEST_RR_S12(4,        min,    0,      0,      x5,   0xffff0000ffff0000, x6,   0x0000ffff0000ffff, x7,   0xffff0000ffff0000)
  TEST_RR_S12(5,        min,    0,      0,      x5,   0x0000ffff0000ffff, x6,   0xffff0000ffff0000, x7,   0xffff0000ffff0000)

  TEST_RR_S12(6,        min,    0,      0,      x5,   0x000f000f000f000f, x6,   0xffffffffffffffff, x7,   0xffffffffffffffff)
  TEST_RR_S12(7,        min,    0,      0,      x5,   0x8000000080000000, x6,   0x7000000070000000, x7,   0x8000000080000000)
  TEST_RR_S12(8,        min,    0,      0,      x5,   0xffff0000ffff0000, x6,   0xffffffffffffffff, x7,   0xffff0000ffff0000)

  TEST_RR_S12(9,        min,    0,      0,      x5,   0x0000ffff0000ffff, x6,   0x0000ffff0000ffff, x7,   0x0000ffff0000ffff)
  TEST_RR_S12(10,       min,    0,      0,      x5,   0x8000000080000000, x6,   0x0000000000000000, x7,   0x8000000080000000)
  TEST_RR_S12(11,       min,    0,      0,      x5,   0xa5a5a5a5a5a5a5a5, x6,   0x5a5a5a5a5a5a5a5a, x7,   0xa5a5a5a5a5a5a5a5)

  TEST_RR_S12(12,       min,    0,      0,      x10,  0xc6c6c6c6c6c6c6c6, x11,  0x6c6c6c6c6c6c6c6c, x12,  0xc6c6c6c6c6c6c6c6)
  TEST_RR_S12(13,       min,    0,      0,      x13,  0xc6c6c6c6c6c6c6c6, x14,  0xc6c6c6c6c6c6c6c6, x15,  0xc6c6c6c6c6c6c6c6)
  TEST_RR_S12(14,       min,    0,      0,      x12,  0x0000111100001111, x10,  0x1010101010101010, x11,  0x0000111100001111)
  TEST_RR_S12(15,       min,    0,      0,      x17,  0xffffffffffffffff, x10,  0xffffffffffffffff, x13,  0xffffffffffffffff)
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       min,    0,      0,      x7,   0x20,   x6,   0x11,   x7,   0x11)
  TEST_RR_S12(17,       min,    0,      0,      x5,   0x01,   x7,   0x02,   x7,   0x01)
  TEST_RR_S12(18,       min,    0,      0,      x7,   0x00,   x7,   0x12,   x7,   0x12)

  TEST_RR_S21(19,       min,    0,      0,      x7,   0x30,   x7,   0x00,   x7,   0x30)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       min,    0,      0,      x0,   0x20,   x6,   0x11,   x7,   0x00)
  TEST_RR_S12(21,       min,    0,      0,      x5,   -0x44,  x0,   0x02,   x7,   -0x44)
  TEST_RR_S12(22,       min,    0,      0,      x0,   0x00,   x0,   0x12,   x7,   0x00)
  TEST_RR_S12(23,       min,    0,      0,      x5,   0x30,   x6,   0x20,   x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_BYP(24,       min,    0,      x5,   0x20,   x6,   0x10,   x10,  0x10)
  TEST_RR_BYP(25,       min,    1,      x5,   0x20,   x6,   0x30,   x10,  0x20)
  TEST_RR_BYP(26,       min,    2,      x5,   0x20,   x6,   0x1f,   x10,  0x1f)
  TEST_RR_BYP(27,       min,    4,      x5,   -0x20,  x6,   -0x14,  x10,  -0x20)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,   rd,   vr
  TEST_RR_S12(28,       min,    1,      0,      x5,   0x30,   x6,   0x20, x7,   0x20)
  TEST_RR_S12(29,       min,    1,      1,      x5,   0x30,   x6,   0x31, x7,   0x30)

  TEST_RR_S21(30,       min,    1,      0,      x5,   0x30,   x6,   0x32, x7,   0x30)
  TEST_RR_S21(31,       min,    1,      1,      x5,   -0x30,  x6,   0x23, x7,   -0x30)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
