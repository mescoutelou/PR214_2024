/*
 * File: orn.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-12 04:30:29 pm
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
  TEST_RR_S12(0,        orn,    0,      0,      x5,   0x0000000000000000, x6,   0x0000000000000000, x7,   0xffffffffffffffff)
  TEST_RR_S12(1,        orn,    0,      0,      x5,   0x0000000000000001, x6,   0x0000000000000001, x7,   0xffffffffffffffff)
  TEST_RR_S12(2,        orn,    0,      0,      x5,   0x0000000000000008, x6,   0x0000000000000009, x7,   0xfffffffffffffffe)

  TEST_RR_S12(3,        orn,    0,      0,      x5,   0xffffffffffffffff, x6,   0x0000000000000000, x7,   0xffffffffffffffff)
  TEST_RR_S12(4,        orn,    0,      0,      x5,   0xffffffff00000000, x6,   0x00000000ffffffff, x7,   0xffffffff00000000)
  TEST_RR_S12(5,        orn,    0,      0,      x5,   0xffffffff00000000, x6,   0xffffffffffffffff, x7,   0xffffffff00000000)

  TEST_RR_S12(6,        orn,    0,      0,      x5,   0x000f000f000f000f, x6,   0xffffffffffffffff, x7,   0x000f000f000f000f)
  TEST_RR_S12(7,        orn,    0,      0,      x5,   0x0ff00ff00ff00ff0, x6,   0x00ff00ff00ff00ff, x7,   0xfff0fff0fff0fff0)
  TEST_RR_S12(8,        orn,    0,      0,      x5,   0xffff0000ffff0000, x6,   0xffffffff00000000, x7,   0xffff0000ffffffff)

  TEST_RR_S12(9,        orn,    0,      0,      x5,   0x0000ffff0000ffff, x6,   0x00000000ffffffff, x7,   0xffffffff0000ffff)
  TEST_RR_S12(10,       orn,    0,      0,      x5,   0x00000000fffffff0, x6,   0x0000000000000001, x7,   0x00000000fffffffe)
  TEST_RR_S12(11,       orn,    0,      0,      x5,   0xa5a5a5a5a5a5a5a5, x6,   0x5a5a5a5a5a5a5a5a, x7,   0xa5a5a5a5a5a5a5a5)

  TEST_RR_S12(12,       orn,    0,      0,      x10,  0xc6c6c6c6c6c6c6c6, x11,  0x6c6c6c6c6c6c6c6c, x12,  0xd7d7d7d7d7d7d7d7)
  TEST_RR_S12(13,       orn,    0,      0,      x13,  0xc6c6c6c6c6c6c6c6, x14,  0xc6c6c6c6c6c6c6c6, x15,  0xffffffffffffffff)
  TEST_RR_S12(14,       orn,    0,      0,      x12,  0x0000000011111111, x10,  0x0000000010101010, x11,  0xffffffffffffffff)
  TEST_RR_S12(15,       orn,    0,      0,      x17,  0xffffffffffffffff, x10,  0xffffffffffffffff, x13,  0xffffffffffffffff)
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                 rs2,  v2,                 rd,   vr
  TEST_RR_S12(16,       orn,    0,      0,      x7,   0x0000000010101010, x6,   0x0000000000000011, x7,   0xfffffffffffffffe)
  TEST_RR_S12(17,       orn,    0,      0,      x5,   0x0000000010101010, x7,   0x0000000000001111, x7,   0xfffffffffffffefe)
  TEST_RR_S12(18,       orn,    0,      0,      x7,   0x0000000010101010, x7,   0x0000000000000011, x7,   0xffffffffffffffff)

  TEST_RR_S21(19,       orn,    0,      0,      x7,   0x0000000010101010, x7,   0x00000000ffffff11, x7,   0xffffffffffffffff)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                 rs2,  v2,                 rd,   vr
  TEST_RR_S12(20,       orn,    0,      0,      x0,   0x0000000011001100, x6,   0x0000000011ff11ff, x7,   0xffffffffee00ee00)
  TEST_RR_S12(21,       orn,    0,      0,      x5,   0x0000000011001100, x0,   0x0000000011ff11ff, x7,   0xffffffffffffffff)
  TEST_RR_S12(22,       orn,    0,      0,      x0,   0x0000000011001100, x0,   0x0000000011ff11ff, x7,   0xffffffffffffffff)
  TEST_RR_S12(23,       orn,    0,      0,      x5,   0x0000000011001100, x6,   0x0000000011ff11ff, x0,   0x0000000000000000)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,                 rs2,  v2,                 rd,   vr
  TEST_RR_BYP(24,       orn,    0,      x5,   0x0000000011110000, x6,   0x000000001fff1fff, x10,  0xfffffffff111e000)
  TEST_RR_BYP(25,       orn,    1,      x5,   0x0000000011110000, x6,   0x00000000f1ff1fff, x10,  0xffffffff1f11e000)
  TEST_RR_BYP(26,       orn,    2,      x5,   0x0000000011110000, x6,   0x00000000fff11fff, x10,  0xffffffff111fe000)
  TEST_RR_BYP(27,       orn,    4,      x5,   0x0000000011110000, x6,   0x00000000f11ff11f, x10,  0xffffffff1ff10ee0)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                 rs2,  v2,                 rd,   vr
  TEST_RR_S12(28,       orn,    1,      0,      x5,   0x0000000000110011, x6,   0x00000000ffff1111, x7,   0xffffffff0011eeff)
  TEST_RR_S12(29,       orn,    1,      1,      x5,   0x0000000000110011, x6,   0x00000000fff1111f, x7,   0xffffffff001feef1)

  TEST_RR_S21(30,       orn,    1,      0,      x5,   0x0000000000110011, x6,   0x0000000011111111, x7,   0xffffffffeeffeeff)
  TEST_RR_S21(31,       orn,    1,      1,      x5,   0x0000000000110011, x6,   0x00000000ffffffff, x7,   0xffffffff00110011)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
