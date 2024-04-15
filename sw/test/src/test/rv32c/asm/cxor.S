/*
 * File: cxor.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-03 11:26:14 am
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
  TEST_C_RR_S12(0,        c.xor,  0,      0,      x8,   0x0000000000000000, x9,   0x0000000000000000, 0x0000000000000000)
  TEST_C_RR_S12(1,        c.xor,  0,      0,      x8,   0x0000000000000001, x9,   0x0000000000000001, 0x0000000000000000)
  TEST_C_RR_S12(2,        c.xor,  0,      0,      x8,   0x0000000000000008, x9,   0x0000000000000008, 0x0000000000000000)

  TEST_C_RR_S12(3,        c.xor,  0,      0,      x8,   0xffffffffffffffff, x9,   0x0000000000000000, 0xffffffffffffffff)
  TEST_C_RR_S12(4,        c.xor,  0,      0,      x8,   0xffffffff00000000, x9,   0x00000000ffffffff, 0xffffffffffffffff)
  TEST_C_RR_S12(5,        c.xor,  0,      0,      x8,   0xffffffff00000000, x9,   0xffffffffffffffff, 0x00000000ffffffff)

  TEST_C_RR_S12(6,        c.xor,  0,      0,      x8,   0x000f000f000f000f, x9,   0xffffffffffffffff, 0xfff0fff0fff0fff0)
  TEST_C_RR_S12(7,        c.xor,  0,      0,      x8,   0x0ff00ff00ff00ff0, x9,   0x00ff00ff00ff00ff, 0x0f0f0f0f0f0f0f0f)
  TEST_C_RR_S12(8,        c.xor,  0,      0,      x8,   0xffff0000ffff0000, x9,   0xffffffff00000000, 0x0000ffffffff0000)

  TEST_C_RR_S12(9,        c.xor,  0,      0,      x8,   0x0000ffff0000ffff, x9,   0x00000000ffffffff, 0x0000ffffffff0000)
  TEST_C_RR_S12(10,       c.xor,  0,      0,      x8,   0x00000000ffffffff, x9,   0x0000000000000001, 0x00000000fffffffe)
  TEST_C_RR_S12(11,       c.xor,  0,      0,      x8,   0xa5a5a5a5a5a5a5a5, x9,   0x5a5a5a5a5a5a5a5a, 0xffffffffffffffff)

  TEST_C_RR_S12(12,       c.xor,  0,      0,      x10,  0xc6c6c6c6c6c6c6c6, x11,  0x6c6c6c6c6c6c6c6c, 0xaaaaaaaaaaaaaaaa)
  TEST_C_RR_S12(13,       c.xor,  0,      0,      x13,  0xc6c6c6c6c6c6c6c6, x14,  0xc6c6c6c6c6c6c6c6, 0x0000000000000000)
  TEST_C_RR_S12(14,       c.xor,  0,      0,      x12,  0x0000000011111111, x10,  0x0000000010101010, 0x0000000001010101)
  TEST_C_RR_S12(15,       c.xor,  0,      0,      x15,  0xffffffffffffffff, x10,  0xffffffffffffffff, 0x0000000000000000)
  
  // ------------------------------
  //            BYPASS
  // ------------------------------
  //            testnum,  instr,  nnop,   rds1, v1,         rs2,  v2,         vr
  TEST_C_RR_BYP(16,       c.xor,  0,      x8,   0x11110000, x9,   0x10001000, 0x01111000)
  TEST_C_RR_BYP(17,       c.xor,  1,      x8,   0x11110000, x9,   0x01001000, 0x10111000)
  TEST_C_RR_BYP(18,       c.xor,  2,      x8,   0x11110000, x9,   0x00011000, 0x11101000)
  TEST_C_RR_BYP(19,       c.xor,  4,      x8,   0x11110000, x9,   0x01100110, 0x10010110)

  //            testnum,  instr,  nnop1,  nnop2,  rds1, v1,         rs2,  v2,         vr
  TEST_C_RR_S12(20,       c.xor,  1,      0,      x8,   0x00110011, x9,   0x00001111, 0x00111100)
  TEST_C_RR_S12(21,       c.xor,  1,      1,      x8,   0x00110011, x9,   0x00011110, 0x00101101)

  TEST_C_RR_S21(22,       c.xor,  1,      0,      x8,   0x00110011, x9,   0x11111111, 0x11001100)
  TEST_C_RR_S21(23,       c.xor,  1,      1,      x8,   0x00110011, x9,   0x00000000, 0x00110011)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
