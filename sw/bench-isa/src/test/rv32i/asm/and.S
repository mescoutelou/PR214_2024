/*
 * File: and.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:33:40 am
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
  TEST_RR_S12(0,        and,    0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(1,        and,    0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000001, x7,   0x0000000000000001)
  TEST_RR_S12(2,        and,    0,      0,      x5,   0x0000000000000008, x6,   0x0000000000000008, x7,   0x0000000000000008)

  TEST_RR_S12(3,        and,    0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(4,        and,    0,      0,      x5,   0xffffffff00000000, x6,   0x00000000ffffffff, x7,   0x0000000000000000)
  TEST_RR_S12(5,        and,    0,      0,      x5,   0xffffffff00000000, x6,   0xffffffffffffffff, x7,   0xffffffff00000000)

  TEST_RR_S12(6,        and,    0,      0,      x5,   0x000f000f000f000f, x6,   0xffffffffffffffff, x7,   0x000f000f000f000f)
  TEST_RR_S12(7,        and,    0,      0,      x5,   0x0ff00ff00ff00ff0, x6,   0x00ff00ff00ff00ff, x7,   0x00f000f000f000f0)
  TEST_RR_S12(8,        and,    0,      0,      x5,   0xffff0000ffff0000, x6,   0xffffffff00000000, x7,   0xffff000000000000)

  TEST_RR_S12(9,        and,    0,      0,      x5,   0x0000ffff0000ffff, x6,   0x00000000ffffffff, x7,   0x000000000000ffff)
  TEST_RR_S12(10,       and,    0,      0,      x5,   0x00000000ffffffff, x6,   0x0000000000000001, x7,   0x0000000000000001)
  TEST_RR_S12(11,       and,    0,      0,      x5,   0xa5a5a5a5a5a5a5a5, x6,   0x5a5a5a5a5a5a5a5a, x7,   0x0000000000000000)

  TEST_RR_S12(12,       and,    0,      0,      x10,  0xc6c6c6c6c6c6c6c6, x11,  0x6c6c6c6c6c6c6c6c, x12,  0x4444444444444444)
  TEST_RR_S12(13,       and,    0,      0,      x13,  0xc6c6c6c6c6c6c6c6, x14,  0xc6c6c6c6c6c6c6c6, x15,  0xc6c6c6c6c6c6c6c6)
  TEST_RR_S12(14,       and,    0,      0,      x12,  0x0000000011111111, x10,  0x0000000010101010, x11,  0x0000000010101010)
  TEST_RR_S12(15,       and,    0,      0,      x17,  0xffffffffffffffff, x10,  0xffffffffffffffff, x13,  0xffffffffffffffff)
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_S12(16,       and,    0,      0,      x7,   0x10101010, x6,   0x00000011, x7,   0x00000010)
  TEST_RR_S12(17,       and,    0,      0,      x5,   0x10101010, x7,   0x00001111, x7,   0x00001010)
  TEST_RR_S12(18,       and,    0,      0,      x7,   0x10101010, x7,   0x00000011, x7,   0x00000011)

  TEST_RR_S21(19,       and,    0,      0,      x7,   0x10101010, x7,   0x00000011, x7,   0x10101010)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_S12(20,       and,    0,      0,      x0,   0x11001100, x6,   0x11001100, x7,   0x00000000)
  TEST_RR_S12(21,       and,    0,      0,      x5,   0x11001100, x0,   0x11001100, x7,   0x00000000)
  TEST_RR_S12(22,       and,    0,      0,      x0,   0x11001100, x0,   0x11001100, x7,   0x00000000)
  TEST_RR_S12(23,       and,    0,      0,      x5,   0x11001100, x6,   0x11001100, x0,   0x00000000)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_BYP(24,       and,    0,      x5,   0x11110000, x6,   0x10001000, x10,  0x10000000)
  TEST_RR_BYP(25,       and,    1,      x5,   0x11110000, x6,   0x01001000, x10,  0x01000000)
  TEST_RR_BYP(26,       and,    2,      x5,   0x11110000, x6,   0x00011000, x10,  0x00010000)
  TEST_RR_BYP(27,       and,    4,      x5,   0x11110000, x6,   0x01100110, x10,  0x01100000)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,         rs2,  v2,         rd,   vr
  TEST_RR_S12(28,       and,    1,      0,      x5,   0x00110011, x6,   0x00001111, x7,   0x00000011)
  TEST_RR_S12(29,       and,    1,      1,      x5,   0x00110011, x6,   0x00011110, x7,   0x00010010)

  TEST_RR_S21(30,       and,    1,      0,      x5,   0x00110011, x6,   0x11111111, x7,   0x00110011)
  TEST_RR_S21(31,       and,    1,      1,      x5,   0x00110011, x6,   0x00000000, x7,   0x00000000)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
