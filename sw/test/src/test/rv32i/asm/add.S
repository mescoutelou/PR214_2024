/*
 * File: add.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:33:33 am
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
  TEST_RR_S12(0,        add,    0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(1,        add,    0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000001, x7,   0x0000000000000002)
  TEST_RR_S12(2,        add,    0,      0,      x5,   0x0000000000000008, x6,   0x0000000000000008, x7,   0x0000000000000010)

  TEST_RR_S12(3,        add,    0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000000, x7,   0xffffffffffffffff)
  TEST_RR_S12(4,        add,    0,      0,      x5,   0xffffffff80000000, x6,   0xffffffff80000000, x7,   0x0000000000000000)
  TEST_RR_S12(5,        add,    0,      0,      x5,   0x0000000000000000, x6,   0xffffffffffffffff, x7,   0xffffffffffffffff)

  TEST_RR_S12(6,        add,    0,      0,      x5,   0x0000000000000002, x6,   0xffffffffffffffff, x7,   0x0000000000000001)
  TEST_RR_S12(7,        add,    0,      0,      x5,   0xffffffffffffffff, x6,   0xffffffffffffffff, x7,   0xfffffffffffffffe)
  TEST_RR_S12(8,        add,    0,      0,      x5,   0x000000000000ffff, x6,   0x000000000000ffff, x7,   0x000000000001fffe)

  TEST_RR_S12(9,        add,    0,      0,      x5,   0xffffffff00000000, x6,   0x00000000ffffffff, x7,   0xffffffffffffffff)
  TEST_RR_S12(10,       add,    0,      0,      x5,   0x00000000ffffffff, x6,   0x0000000000000001, x7,   0x0000000100000000)
  TEST_RR_S12(11,       add,    0,      0,      x5,   0xf0f0f0f0f0f0f0f0, x6,   0x0f0f0f0f0f0f0f0f, x7,   0xffffffffffffffff)

  TEST_RR_S12(12,       add,    0,      0,      x10,  0x0000000000008fff, x11,  0x0000000000007000, x12,  0x000000000000ffff)
  TEST_RR_S12(13,       add,    0,      0,      x13,  0x0000000000000001, x14,  0xffffffffffffffff, x15,  0x0000000000000000)
  TEST_RR_S12(14,       add,    0,      0,      x12,  0xffff0000ffff0002, x10,  0x0000ffff0000ffff, x11,  0x0000000000000001)
  TEST_RR_S12(15,       add,    0,      0,      x17,  0x0000000010000000, x10,  0x000000000fffffff, x13,  0x000000001fffffff)
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       add,    0,      0,      x7,   0x20,   x6,   0x11,   x7,   0x31)
  TEST_RR_S12(17,       add,    0,      0,      x5,   0x44,   x7,   0x02,   x7,   0x46)
  TEST_RR_S12(18,       add,    0,      0,      x7,   0x00,   x7,   0x12,   x7,   0x24)

  TEST_RR_S21(19,       add,    0,      0,      x7,   0x30,   x7,   0x00,   x7,   0x60)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       add,    0,      0,      x0,   0x20,   x6,   0x11,   x7,   0x11)
  TEST_RR_S12(21,       add,    0,      0,      x5,   0x44,   x0,   0x02,   x7,   0x44)
  TEST_RR_S12(22,       add,    0,      0,      x0,   0x00,   x0,   0x12,   x7,   0x00)
  TEST_RR_S12(23,       add,    0,      0,      x5,   0x30,   x6,   0x20,   x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,   rd,   vr
  TEST_RR_BYP(24,       add,    0,      x5,   0x20,   x6,   0x10, x10,  0x30)
  TEST_RR_BYP(25,       add,    1,      x5,   0x20,   x6,   0x11, x10,  0x31)
  TEST_RR_BYP(26,       add,    2,      x5,   0x20,   x6,   0x12, x10,  0x32)
  TEST_RR_BYP(27,       add,    4,      x5,   0x20,   x6,   0x14, x10,  0x34)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,   rs2,  v2,   rd,   vr
  TEST_RR_S12(28,       add,    1,      0,      x5,   0x30, x6,   0x20, x7,   0x50)
  TEST_RR_S12(29,       add,    1,      1,      x5,   0x30, x6,   0x21, x7,   0x51)

  TEST_RR_S21(30,       add,    1,      0,      x5,   0x30, x6,   0x22, x7,   0x52)
  TEST_RR_S21(31,       add,    1,      1,      x5,   0x30, x6,   0x23, x7,   0x53)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
