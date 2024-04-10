/*
 * File: xor.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:36:31 am
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
  TEST_RR_S12(0,        xor,    0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(1,        xor,    0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000001, x7,   0x0000000000000000)
  TEST_RR_S12(2,        xor,    0,      0,      x5,   0x0000000000000008, x6,   0x0000000000000008, x7,   0x0000000000000000)

  TEST_RR_S12(3,        xor,    0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000000, x7,   0xffffffffffffffff)
  TEST_RR_S12(4,        xor,    0,      0,      x5,   0xffffffff00000000, x6,   0x00000000ffffffff, x7,   0xffffffffffffffff)
  TEST_RR_S12(5,        xor,    0,      0,      x5,   0xffffffff00000000, x6,   0xffffffffffffffff, x7,   0x00000000ffffffff)

  TEST_RR_S12(6,        xor,    0,      0,      x5,   0x000f000f000f000f, x6,   0xffffffffffffffff, x7,   0xfff0fff0fff0fff0)
  TEST_RR_S12(7,        xor,    0,      0,      x5,   0x0ff00ff00ff00ff0, x6,   0x00ff00ff00ff00ff, x7,   0x0f0f0f0f0f0f0f0f)
  TEST_RR_S12(8,        xor,    0,      0,      x5,   0xffff0000ffff0000, x6,   0xffffffff00000000, x7,   0x0000ffffffff0000)

  TEST_RR_S12(9,        xor,    0,      0,      x5,   0x0000ffff0000ffff, x6,   0x00000000ffffffff, x7,   0x0000ffffffff0000)
  TEST_RR_S12(10,       xor,    0,      0,      x5,   0x00000000ffffffff, x6,   0x0000000000000001, x7,   0x00000000fffffffe)
  TEST_RR_S12(11,       xor,    0,      0,      x5,   0xa5a5a5a5a5a5a5a5, x6,   0x5a5a5a5a5a5a5a5a, x7,   0xffffffffffffffff)

  TEST_RR_S12(12,       xor,    0,      0,      x10,  0xc6c6c6c6c6c6c6c6, x11,  0x6c6c6c6c6c6c6c6c, x12,  0xaaaaaaaaaaaaaaaa)
  TEST_RR_S12(13,       xor,    0,      0,      x13,  0xc6c6c6c6c6c6c6c6, x14,  0xc6c6c6c6c6c6c6c6, x15,  0x0000000000000000)
  TEST_RR_S12(14,       xor,    0,      0,      x12,  0x0000000011111111, x10,  0x0000000010101010, x11,  0x0000000001010101)
  TEST_RR_S12(15,       xor,    0,      0,      x17,  0xffffffffffffffff, x10,  0xffffffffffffffff, x13,  0x0000000000000000)
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_S12(16,       xor,    0,      0,      x7,   0x10101010, x6,   0x00000011, x7,   0x10101001)
  TEST_RR_S12(17,       xor,    0,      0,      x5,   0x10101010, x7,   0x00001111, x7,   0x10100101)
  TEST_RR_S12(18,       xor,    0,      0,      x7,   0x10101010, x7,   0x00000011, x7,   0x00000000)

  TEST_RR_S21(19,       xor,    0,      0,      x7,   0x10101010, x7,   0x00000011, x7,   0x00000000)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_S12(20,       xor,    0,      0,      x0,   0x11001100, x6,   0x11001100, x7,   0x11001100)
  TEST_RR_S12(21,       xor,    0,      0,      x5,   0x11001100, x0,   0x11001100, x7,   0x11001100)
  TEST_RR_S12(22,       xor,    0,      0,      x0,   0x11001100, x0,   0x11001100, x7,   0x00000000)
  TEST_RR_S12(23,       xor,    0,      0,      x5,   0x11001100, x6,   0x11001100, x0,   0x00000000)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_BYP(24,       xor,    0,      x5,   0x11110000, x6,   0x10001000, x10,  0x01111000)
  TEST_RR_BYP(25,       xor,    1,      x5,   0x11110000, x6,   0x01001000, x10,  0x10111000)
  TEST_RR_BYP(26,       xor,    2,      x5,   0x11110000, x6,   0x00011000, x10,  0x11101000)
  TEST_RR_BYP(27,       xor,    4,      x5,   0x11110000, x6,   0x01100110, x10,  0x10010110)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_S12(28,       xor,    1,      0,      x5,   0x00110011, x6,   0x00001111, x7,   0x00111100)
  TEST_RR_S12(29,       xor,    1,      1,      x5,   0x00110011, x6,   0x00011110, x7,   0x00101101)

  TEST_RR_S21(30,       xor,    1,      0,      x5,   0x00110011, x6,   0x11111111, x7,   0x11001100)
  TEST_RR_S21(31,       xor,    1,      1,      x5,   0x00110011, x6,   0x00000000, x7,   0x00110011)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
