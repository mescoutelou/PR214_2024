/*
 * File: andn.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-12 04:02:53 pm
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
  TEST_RR_S12(0,        andn,   0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(1,        andn,   0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000001, x7,   0x0000000000000000)
  TEST_RR_S12(2,        andn,   0,      0,      x5,   0x0000000000000008, x6,   0x0000000000000007, x7,   0x0000000000000008)

  TEST_RR_S12(3,        andn,   0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000000, x7,   0xffffffffffffffff)
  TEST_RR_S12(4,        andn,   0,      0,      x5,   0xffffffff00000000, x6,   0x00000000ffffffff, x7,   0xffffffff00000000)
  TEST_RR_S12(5,        andn,   0,      0,      x5,   0xffffffff00000000, x6,   0xffffffff00000000, x7,   0x0000000000000000)

  TEST_RR_S12(6,        andn,   0,      0,      x5,   0x000f000f000f000f, x6,   0x0000000000000000, x7,   0x000f000f000f000f)
  TEST_RR_S12(7,        andn,   0,      0,      x5,   0x0ff00ff00ff00ff0, x6,   0x00ff00ff00ff00ff, x7,   0x0f000f000f000f00)
  TEST_RR_S12(8,        andn,   0,      0,      x5,   0xffff0000ffff0000, x6,   0xffffffff00000000, x7,   0x00000000ffff0000)

  TEST_RR_S12(9,        andn,   0,      0,      x5,   0x0000ffff0000ffff, x6,   0x00000000ffffffff, x7,   0x0000ffff00000000)
  TEST_RR_S12(10,       andn,   0,      0,      x5,   0x00000000ffffffff, x6,   0x0000000000000001, x7,   0x00000000fffffffe)
  TEST_RR_S12(11,       andn,   0,      0,      x5,   0xa5a5a5a5a5a5a5a5, x6,   0x5a5a5a5a5a5a5a5a, x7,   0xa5a5a5a5a5a5a5a5)

  TEST_RR_S12(12,       andn,   0,      0,      x10,  0xc6c6c6c6c6c6c6c6, x11,  0x6c6c6c6c6c6c6c6c, x12,  0x8282828282828282)
  TEST_RR_S12(13,       andn,   0,      0,      x13,  0xc6c6c6c6c6c6c6c6, x14,  0xc6c6c6c6c6c6c6c6, x15,  0x0000000000000000)
  TEST_RR_S12(14,       andn,   0,      0,      x12,  0x0000000011111111, x10,  0x0000000010101010, x11,  0x0000000001010101)
  TEST_RR_S12(15,       andn,   0,      0,      x17,  0xffffffffffffffff, x10,  0xffffffffffffffff, x13,  0x0000000000000000)
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_S12(16,       andn,   0,      0,      x7,   0x10101010, x6,   0x00000011, x7,   0x10101000)
  TEST_RR_S12(17,       andn,   0,      0,      x5,   0x10101010, x7,   0x00001111, x7,   0x10100000)
  TEST_RR_S12(18,       andn,   0,      0,      x7,   0x10101010, x7,   0x00000011, x7,   0x00000000)

  TEST_RR_S21(19,       andn,   0,      0,      x7,   0x10101010, x7,   0x00000011, x7,   0x00000000)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_S12(20,       andn,   0,      0,      x0,   0x11001100, x6,   0x11001100, x7,   0x00000000)
  TEST_RR_S12(21,       andn,   0,      0,      x5,   0x11001100, x0,   0x11001100, x7,   0x11001100)
  TEST_RR_S12(22,       andn,   0,      0,      x0,   0x11001100, x0,   0x11001100, x7,   0x00000000)
  TEST_RR_S12(23,       andn,   0,      0,      x5,   0x11001100, x6,   0x11001100, x0,   0x00000000)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_BYP(24,       andn,   0,      x5,   0x11110000, x6,   0x10001000, x10,  0x01110000)
  TEST_RR_BYP(25,       andn,   1,      x5,   0x11110000, x6,   0x01001000, x10,  0x10110000)
  TEST_RR_BYP(26,       andn,   2,      x5,   0x11110000, x6,   0x00011000, x10,  0x11100000)
  TEST_RR_BYP(27,       andn,   4,      x5,   0x11110000, x6,   0x01100110, x10,  0x10010000)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_S12(28,       andn,   1,      0,      x5,   0x00110011, x6,   0x00001111, x7,   0x00110000)
  TEST_RR_S12(29,       andn,   1,      1,      x5,   0x00110011, x6,   0x00011110, x7,   0x00100001)

  TEST_RR_S21(30,       andn,   1,      0,      x5,   0x00110011, x6,   0x11111111, x7,   0x00000000)
  TEST_RR_S21(31,       andn,   1,      1,      x5,   0x00110011, x6,   0x00000000, x7,   0x00110011)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
