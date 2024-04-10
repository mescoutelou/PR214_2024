/*
 * File: cmv.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-03 04:41:09 pm
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
TEST_INIT(24)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //           ARITHMETIC
  // ------------------------------
  //            testnum,  instr,  nnop1,  nnop2,  rds1, v1,                 rs2,  v2,                 vr
  TEST_C_RR_S12(0,        c.mv,   0,      0,      x8,   0x0000000000000000, x9,   0x0000000000000000, 0x0000000000000000)
  TEST_C_RR_S12(1,        c.mv,   0,      0,      x8,   0x0000000000000001, x9,   0x0000000000000001, 0x0000000000000001)
  TEST_C_RR_S12(2,        c.mv,   0,      0,      x8,   0x0000000000000008, x9,   0x0000000000000008, 0x0000000000000008)

  TEST_C_RR_S12(3,        c.mv,   0,      0,      x8,   0xffffffffffffffff, x9,   0x0000000000000000, 0x0000000000000000)
  TEST_C_RR_S12(4,        c.mv,   0,      0,      x8,   0xffffffff80000000, x9,   0xffffffff80000000, 0xffffffff80000000)
  TEST_C_RR_S12(5,        c.mv,   0,      0,      x8,   0x0000000000000000, x9,   0xffffffffffffffff, 0xffffffffffffffff)

  TEST_C_RR_S12(6,        c.mv,   0,      0,      x8,   0x0000000000000002, x9,   0xffffffffffffffff, 0xffffffffffffffff)
  TEST_C_RR_S12(7,        c.mv,   0,      0,      x8,   0xffffffffffffffff, x9,   0xffffffffffffffff, 0xffffffffffffffff)
  TEST_C_RR_S12(8,        c.mv,   0,      0,      x8,   0x000000000000ffff, x9,   0x000000000000ffff, 0x000000000000ffff)

  TEST_C_RR_S12(9,        c.mv,   0,      0,      x8,   0xffffffff00000000, x9,   0x00000000ffffffff, 0x00000000ffffffff)
  TEST_C_RR_S12(10,       c.mv,   0,      0,      x8,   0x00000000ffffffff, x9,   0x0000000000000001, 0x0000000000000001)
  TEST_C_RR_S12(11,       c.mv,   0,      0,      x8,   0xf0f0f0f0f0f0f0f0, x9,   0x0f0f0f0f0f0f0f0f, 0x0f0f0f0f0f0f0f0f)

  TEST_C_RR_S12(12,       c.mv,   0,      0,      x10,  0x0000000000008fff, x11,  0x0000000000007000, 0x0000000000007000)
  TEST_C_RR_S12(13,       c.mv,   0,      0,      x13,  0x0000000000000001, x14,  0xffffffffffffffff, 0xffffffffffffffff)
  TEST_C_RR_S12(14,       c.mv,   0,      0,      x12,  0xffff0000ffff0002, x10,  0x0000ffff0000ffff, 0x0000ffff0000ffff)
  TEST_C_RR_S12(15,       c.mv,   0,      0,      x17,  0x0000000010000000, x10,  0x000000000fffffff, 0x000000000fffffff)
  
  // ------------------------------
  //            BYPASS
  // ------------------------------
  //            testnum,  instr,  nnop,   rds1, v1,     rs2,  v2,   vr
  TEST_C_RR_BYP(16,       c.mv,   0,      x8,   0x20,   x9,   0x10, 0x10)
  TEST_C_RR_BYP(17,       c.mv,   1,      x8,   0x20,   x9,   0x11, 0x11)
  TEST_C_RR_BYP(18,       c.mv,   2,      x8,   0x20,   x9,   0x12, 0x12)
  TEST_C_RR_BYP(19,       c.mv,   4,      x8,   0x20,   x9,   0x14, 0x14)

  //            testnum,  instr,  nnop1,  nnop2,  rds1, v1,   rs2,  v2,   vr
  TEST_C_RR_S12(20,       c.mv,   1,      0,      x8,   0x30, x9,   0x20, 0x20)
  TEST_C_RR_S12(21,       c.mv,   1,      1,      x8,   0x30, x9,   0x21, 0x21)

  TEST_C_RR_S21(22,       c.mv,   1,      0,      x8,   0x30, x9,   0x22, 0x22)
  TEST_C_RR_S21(23,       c.mv,   1,      1,      x8,   0x30, x9,   0x23, 0x23)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
