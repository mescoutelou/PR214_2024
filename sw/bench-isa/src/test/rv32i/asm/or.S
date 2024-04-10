/*
 * File: or.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:35:30 am
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
  TEST_RR_S12(0,        or,     0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(1,        or,     0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000001, x7,   0x0000000000000001)
  TEST_RR_S12(2,        or,     0,      0,      x5,   0x0000000000000008, x6,   0x0000000000000008, x7,   0x0000000000000008)

  TEST_RR_S12(3,        or,     0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000000, x7,   0xffffffffffffffff)
  TEST_RR_S12(4,        or,     0,      0,      x5,   0xffffffff00000000, x6,   0x00000000ffffffff, x7,   0xffffffffffffffff)
  TEST_RR_S12(5,        or,     0,      0,      x5,   0xffffffff00000000, x6,   0xffffffffffffffff, x7,   0xffffffffffffffff)

  TEST_RR_S12(6,        or,     0,      0,      x5,   0x000f000f000f000f, x6,   0xffffffffffffffff, x7,   0xffffffffffffffff)
  TEST_RR_S12(7,        or,     0,      0,      x5,   0x0ff00ff00ff00ff0, x6,   0x00ff00ff00ff00ff, x7,   0x0fff0fff0fff0fff)
  TEST_RR_S12(8,        or,     0,      0,      x5,   0xffff0000ffff0000, x6,   0xffffffff00000000, x7,   0xffffffffffff0000)

  TEST_RR_S12(9,        or,     0,      0,      x5,   0x0000ffff0000ffff, x6,   0x00000000ffffffff, x7,   0x0000ffffffffffff)
  TEST_RR_S12(10,       or,     0,      0,      x5,   0x00000000ffffffff, x6,   0x0000000000000001, x7,   0x00000000ffffffff)
  TEST_RR_S12(11,       or,     0,      0,      x5,   0xa5a5a5a5a5a5a5a5, x6,   0x5a5a5a5a5a5a5a5a, x7,   0xffffffffffffffff)

  TEST_RR_S12(12,       or,     0,      0,      x10,  0xc6c6c6c6c6c6c6c6, x11,  0x6c6c6c6c6c6c6c6c, x12,  0xeeeeeeeeeeeeeeee)
  TEST_RR_S12(13,       or,     0,      0,      x13,  0xc6c6c6c6c6c6c6c6, x14,  0xc6c6c6c6c6c6c6c6, x15,  0xc6c6c6c6c6c6c6c6)
  TEST_RR_S12(14,       or,     0,      0,      x12,  0x0000000011111111, x10,  0x0000000010101010, x11,  0x0000000011111111)
  TEST_RR_S12(15,       or,     0,      0,      x17,  0xffffffffffffffff, x10,  0xffffffffffffffff, x13,  0xffffffffffffffff)
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_S12(16,       or,     0,      0,      x7,   0x10101010, x6,   0x00000011, x7,   0x10101011)
  TEST_RR_S12(17,       or,     0,      0,      x5,   0x10101010, x7,   0x00001111, x7,   0x10101111)
  TEST_RR_S12(18,       or,     0,      0,      x7,   0x10101010, x7,   0x00000011, x7,   0x00000011)

  TEST_RR_S21(19,       or,     0,      0,      x7,   0x10101010, x7,   0x00000011, x7,   0x10101010)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_S12(20,       or,     0,      0,      x0,   0x11001100, x6,   0x11001100, x7,   0x11001100)
  TEST_RR_S12(21,       or,     0,      0,      x5,   0x11001100, x0,   0x11001100, x7,   0x11001100)
  TEST_RR_S12(22,       or,     0,      0,      x0,   0x11001100, x0,   0x11001100, x7,   0x00000000)
  TEST_RR_S12(23,       or,     0,      0,      x5,   0x11001100, x6,   0x11001100, x0,   0x00000000)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_BYP(24,       or,     0,      x5,   0x11110000, x6,   0x10001000, x10,  0x11111000)
  TEST_RR_BYP(25,       or,     1,      x5,   0x11110000, x6,   0x01001000, x10,  0x11111000)
  TEST_RR_BYP(26,       or,     2,      x5,   0x11110000, x6,   0x00011000, x10,  0x11111000)
  TEST_RR_BYP(27,       or,     4,      x5,   0x11110000, x6,   0x01100110, x10,  0x11110110)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_S12(28,       or,     1,      0,      x5,   0x00110011, x6,   0x00001111, x7,   0x00111111)
  TEST_RR_S12(29,       or,     1,      1,      x5,   0x00110011, x6,   0x00011110, x7,   0x00111111)

  TEST_RR_S21(30,       or,     1,      0,      x5,   0x00110011, x6,   0x11111111, x7,   0x11111111)
  TEST_RR_S21(31,       or,     1,      1,      x5,   0x00110011, x6,   0x00000000, x7,   0x00110011)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
