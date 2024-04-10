/*
 * File: and.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-03 11:26:42 am
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
  //             LOGIC
  // ------------------------------
  //            testnum,  instr,  nnop1,  nnop2,  rds1, v1,                 rs2,  v2,                 vr
  TEST_C_RR_S12(0,        c.and,  0,      0,      x8,   0x0000000000000000, x9,   0x0000000000000000, 0x0000000000000000)
  TEST_C_RR_S12(1,        c.and,  0,      0,      x8,   0x0000000000000001, x9,   0x0000000000000001, 0x0000000000000001)
  TEST_C_RR_S12(2,        c.and,  0,      0,      x8,   0x0000000000000008, x9,   0x0000000000000008, 0x0000000000000008)

  TEST_C_RR_S12(3,        c.and,  0,      0,      x8,   0xffffffffffffffff, x9,   0x0000000000000000, 0x0000000000000000)
  TEST_C_RR_S12(4,        c.and,  0,      0,      x8,   0xffffffff00000000, x9,   0x00000000ffffffff, 0x0000000000000000)
  TEST_C_RR_S12(5,        c.and,  0,      0,      x8,   0xffffffff00000000, x9,   0xffffffffffffffff, 0xffffffff00000000)

  TEST_C_RR_S12(6,        c.and,  0,      0,      x8,   0x000f000f000f000f, x9,   0xffffffffffffffff, 0x000f000f000f000f)
  TEST_C_RR_S12(7,        c.and,  0,      0,      x8,   0x0ff00ff00ff00ff0, x9,   0x00ff00ff00ff00ff, 0x00f000f000f000f0)
  TEST_C_RR_S12(8,        c.and,  0,      0,      x8,   0xffff0000ffff0000, x9,   0xffffffff00000000, 0xffff000000000000)

  TEST_C_RR_S12(9,        c.and,  0,      0,      x8,   0x0000ffff0000ffff, x9,   0x00000000ffffffff, 0x000000000000ffff)
  TEST_C_RR_S12(10,       c.and,  0,      0,      x8,   0x00000000ffffffff, x9,   0x0000000000000001, 0x0000000000000001)
  TEST_C_RR_S12(11,       c.and,  0,      0,      x8,   0xa5a5a5a5a5a5a5a5, x9,   0x5a5a5a5a5a5a5a5a, 0x0000000000000000)

  TEST_C_RR_S12(12,       c.and,  0,      0,      x10,  0xc6c6c6c6c6c6c6c6, x11,  0x6c6c6c6c6c6c6c6c, 0x4444444444444444)
  TEST_C_RR_S12(13,       c.and,  0,      0,      x13,  0xc6c6c6c6c6c6c6c6, x14,  0xc6c6c6c6c6c6c6c6, 0xc6c6c6c6c6c6c6c6)
  TEST_C_RR_S12(14,       c.and,  0,      0,      x12,  0x0000000011111111, x10,  0x0000000010101010, 0x0000000010101010)
  TEST_C_RR_S12(15,       c.and,  0,      0,      x15,  0xffffffffffffffff, x10,  0xffffffffffffffff, 0xffffffffffffffff)
  
  // ------------------------------
  //            BYPASS
  // ------------------------------
  //            testnum,  instr,  nnop,   rds1, v1,         rs2,  v2,         vr
  TEST_C_RR_BYP(16,       c.and,  0,      x8,   0x11110000, x9,   0x10001000, 0x10000000)
  TEST_C_RR_BYP(17,       c.and,  1,      x8,   0x11110000, x9,   0x01001000, 0x01000000)
  TEST_C_RR_BYP(18,       c.and,  2,      x8,   0x11110000, x9,   0x00011000, 0x00010000)
  TEST_C_RR_BYP(19,       c.and,  4,      x8,   0x11110000, x9,   0x01100110, 0x01100000)

  //            testnum,  instr,  nnop1,  nnop2,  rds1, v1,         rs2,  v2,         vr
  TEST_C_RR_S12(20,       c.and,  1,      0,      x8,   0x00110011, x9,   0x00001111, 0x00000011)
  TEST_C_RR_S12(21,       c.and,  1,      1,      x8,   0x00110011, x9,   0x00011110, 0x00010010)

  TEST_C_RR_S21(22,       c.and,  1,      0,      x8,   0x00110011, x9,   0x11111111, 0x00110011)
  TEST_C_RR_S21(23,       c.and,  1,      1,      x8,   0x00110011, x9,   0x00000000, 0x00000000)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
