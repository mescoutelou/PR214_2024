/*
 * File: csub.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-03 11:20:56 am
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
TEST_INIT(26)

// ******************************
//             BODY
// ******************************
test_body:

  // ------------------------------
  //           ARITHMETIC
  // ------------------------------
  //            testnum,  instr,  nnop1,  nnop2,  rds1, v1,                 rs2,  v2,                 vr
  TEST_C_RR_S12(0,        c.sub,  0,      0,      x8,   0x0000000000000000, x9,   0x0000000000000000, 0x0000000000000000)
  TEST_C_RR_S12(1,        c.sub,  0,      0,      x8,   0x0000000000000000, x9,   0x0000000000000001, 0xffffffffffffffff)
  TEST_C_RR_S12(2,        c.sub,  0,      0,      x8,   0x0000000000000008, x9,   0x0000000000000008, 0x0000000000000000)

  TEST_C_RR_S12(3,        c.sub,  0,      0,      x8,   0xffffffffffffffff, x9,   0x0000000000000000, 0xffffffffffffffff)
  TEST_C_RR_S12(4,        c.sub,  0,      0,      x8,   0xffffffff80000000, x9,   0xffffffff80000000, 0x0000000000000000)
  TEST_C_RR_S12(5,        c.sub,  0,      0,      x8,   0x0000000000000000, x9,   0xffffffffffffffff, 0x0000000000000001)

  TEST_C_RR_S12(6,        c.sub,  0,      0,      x8,   0x0000000000000002, x9,   0xffffffffffffffff, 0x0000000000000003)
  TEST_C_RR_S12(7,        c.sub,  0,      0,      x8,   0xffffffffffffffff, x9,   0xffffffffffffffff, 0x0000000000000000)
  TEST_C_RR_S12(8,        c.sub,  0,      0,      x8,   0xffffffffffffffff, x9,   0x0000000000000001, 0xfffffffffffffffe)

  TEST_C_RR_S12(9,        c.sub,  0,      0,      x8,   0xffffffff00000000, x9,   0x00000000ffffffff, 0xfffffffe00000001)
  TEST_C_RR_S12(10,       c.sub,  0,      0,      x8,   0x00000000ffffffff, x9,   0x0000000000000001, 0x00000000fffffffe)
  TEST_C_RR_S12(11,       c.sub,  0,      0,      x8,   0xf0f0f0f0f0f0f0f0, x9,   0x0f0f0f0f0f0f0f0f, 0xe1e1e1e1e1e1e1e1)

  TEST_C_RR_S12(12,       c.sub,  0,      0,      x9,   0x0000000000008fff, x11,  0x0000000000007000, 0x0000000000001fff)
  TEST_C_RR_S12(13,       c.sub,  0,      0,      x13,  0x0000000000000001, x14,  0xffffffffffffffff, 0x0000000000000002)
  TEST_C_RR_S12(14,       c.sub,  0,      0,      x12,  0xffff0000ffff0002, x9,   0x0000ffff0000ffff, 0xfffe0001fffe0003)
  TEST_C_RR_S12(15,       c.sub,  0,      0,      x15,  0x0000000010000000, x9,   0x000000000fffffff, 0x0000000000000001)  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //            testnum,  instr,  nnop1,  nnop2,  rds1, v1,     rs2,  v2,     vr
  TEST_C_RR_S12(16,       c.sub,  0,      0,      x9,   0x20,   x9,   0x11,   0x00)
  TEST_C_RR_S12(17,       c.sub,  0,      0,      x12,  0x44,   x12,  0x02,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //            testnum,  instr,  nnop,   rds1, v1,     rs2,  v2,   vr
  TEST_C_RR_BYP(18,       c.sub,  0,      x8,   0x20,   x9,   0x10, 0x10)
  TEST_C_RR_BYP(19,       c.sub,  1,      x8,   0x20,   x9,   0x11, 0x0f)
  TEST_C_RR_BYP(20,       c.sub,  2,      x8,   0x20,   x9,   0x12, 0x0e)
  TEST_C_RR_BYP(21,       c.sub,  4,      x8,   0x20,   x9,   0x14, 0x0c)

  //            testnum,  instr,  nnop1,  nnop2,  rds1, v1,   rs2,  v2,   vr
  TEST_C_RR_S12(22,       c.sub,  1,      0,      x8,   0x30, x9,   0x20, 0x10)
  TEST_C_RR_S12(23,       c.sub,  1,      1,      x8,   0x30, x9,   0x21, 0x0f)

  TEST_C_RR_S21(24,       c.sub,  1,      0,      x8,   0x30, x9,   0x22, 0x0e)
  TEST_C_RR_S21(25,       c.sub,  1,      1,      x8,   0x30, x9,   0x23, 0x0d)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
