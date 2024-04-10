/*
 * File: xnor.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-12 05:41:09 pm
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
  TEST_RR_S12(0,        xnor,   0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0xffffffffffffffff)
  TEST_RR_S12(1,        xnor,   0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000001, x7,   0xffffffffffffffff)
  TEST_RR_S12(2,        xnor,   0,      0,      x5,   0x0000000000000008, x6,   0x0000000000000008, x7,   0xffffffffffffffff)

  TEST_RR_S12(3,        xnor,   0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000000, x7,   0x0000000000000000)
  TEST_RR_S12(4,        xnor,   0,      0,      x5,   0xffffffff00000000, x6,   0x00000000ffffffff, x7,   0x0000000000000000)
  TEST_RR_S12(5,        xnor,   0,      0,      x5,   0xffffffff00000000, x6,   0xffffffffffffffff, x7,   0xffffffff00000000)

  TEST_RR_S12(6,        xnor,   0,      0,      x5,   0x000f000f000f000f, x6,   0xffffffffffffffff, x7,   0x000f000f000f000f)
  TEST_RR_S12(7,        xnor,   0,      0,      x5,   0x0ff00ff00ff00ff0, x6,   0x00ff00ff00ff00ff, x7,   0xf0f0f0f0f0f0f0f0)
  TEST_RR_S12(8,        xnor,   0,      0,      x5,   0xffff0000ffff0000, x6,   0xffffffff00000000, x7,   0xffff00000000ffff)

  TEST_RR_S12(9,        xnor,   0,      0,      x5,   0x0000ffff0000ffff, x6,   0x00000000ffffffff, x7,   0xffff00000000ffff)
  TEST_RR_S12(10,       xnor,   0,      0,      x5,   0x00000000ffffffff, x6,   0x0000000000000001, x7,   0xffffffff00000001)
  TEST_RR_S12(11,       xnor,   0,      0,      x5,   0xa5a5a5a5a5a5a5a5, x6,   0x5a5a5a5a5a5a5a5a, x7,   0x0000000000000000)

  TEST_RR_S12(12,       xnor,   0,      0,      x10,  0xc6c6c6c6c6c6c6c6, x11,  0x6c6c6c6c6c6c6c6c, x12,  0x5555555555555555)
  TEST_RR_S12(13,       xnor,   0,      0,      x13,  0xc6c6c6c6c6c6c6c6, x14,  0xc6c6c6c6c6c6c6c6, x15,  0xffffffffffffffff)
  TEST_RR_S12(14,       xnor,   0,      0,      x12,  0x0000000011111111, x10,  0x0000000010101010, x11,  0xfffffffffefefefe)
  TEST_RR_S12(15,       xnor,   0,      0,      x17,  0xffffffffffffffff, x10,  0xffffffffffffffff, x13,  0xffffffffffffffff)
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                 rs2,  v2,                 rd,   vr
  TEST_RR_S12(16,       xnor,   0,      0,      x7,   0x0000000010101010, x6,   0x0000000000000011, x7,   0x00000000efefeffe)
  TEST_RR_S12(17,       xnor,   0,      0,      x5,   0x0000000010101010, x7,   0x0000000000001111, x7,   0x00000000efeffefe)
  TEST_RR_S12(18,       xnor,   0,      0,      x7,   0x0000000010101010, x7,   0x0000000000000011, x7,   0xffffffffffffffff)

  TEST_RR_S21(19,       xnor,   0,      0,      x7,   0x0000000010101010, x7,   0x0000000000000011, x7,   0xffffffffffffffff)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                 rs2,  v2,                 rd,   vr
  TEST_RR_S12(20,       xnor,   0,      0,      x0,   0x0000000011001100, x6,   0x0000000011001100, x7,   0xffffffffeeffeeff)
  TEST_RR_S12(21,       xnor,   0,      0,      x5,   0x0000000011001100, x0,   0x0000000011001100, x7,   0xffffffffeeffeeff)
  TEST_RR_S12(22,       xnor,   0,      0,      x0,   0x0000000011001100, x0,   0x0000000011001100, x7,   0xffffffffffffffff)
  TEST_RR_S12(23,       xnor,   0,      0,      x5,   0x0000000011001100, x6,   0x0000000011001100, x0,   0x0000000000000000)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,                 rs2,  v2,                 rd,   vr
  TEST_RR_BYP(24,       xnor,   0,      x5,   0x0000000011110000, x6,   0x0000000010001000, x10,  0xfffffffffeeeefff)
  TEST_RR_BYP(25,       xnor,   1,      x5,   0x0000000011110000, x6,   0x0000000001001000, x10,  0xffffffffefeeefff)
  TEST_RR_BYP(26,       xnor,   2,      x5,   0x0000000011110000, x6,   0x0000000000011000, x10,  0xffffffffeeefefff)
  TEST_RR_BYP(27,       xnor,   4,      x5,   0x0000000011110000, x6,   0x0000000001100110, x10,  0xffffffffeffefeef)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                 rs2,  v2,                 rd,   vr
  TEST_RR_S12(28,       xnor,   1,      0,      x5,   0x0000000000110011, x6,   0x0000000000001111, x7,   0xffffffffffeeeeff)
  TEST_RR_S12(29,       xnor,   1,      1,      x5,   0x0000000000110011, x6,   0x0000000000011110, x7,   0xffffffffffefeefe)

  TEST_RR_S21(30,       xnor,   1,      0,      x5,   0x0000000000110011, x6,   0x0000000011111111, x7,   0xffffffffeeffeeff)
  TEST_RR_S21(31,       xnor,   1,      1,      x5,   0x0000000000110011, x6,   0x0000000000000000, x7,   0xffffffffffeeffee)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
