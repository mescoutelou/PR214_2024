/*
 * File: amoadd-w.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-06-13 05:40:56 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "../../../common/macro.h"
#include "macro-a.h"


// ******************************
//            INIT
// ******************************
TEST_INIT(25)

  la x10, data0
  la x11, 0
  la x12, 4
init_loop:
  beq x11, x12, init_end
  sw x0, 0(x10)
  addi x10, x10, 4
  addi x11, x11, 1
  j init_loop
init_end:
  nop

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //            ACCESS
  // ------------------------------
  //       testnum, instr_amo,  instr_ld, nnop, rs1,  tbase, rs2, v2,         rd,   vr1,        vr2
  TEST_AMO(0,       amoadd.w,   lw,       0,    x5,   data0, x6,  0x00000000, x7,   0x00000000, 0x00000000)

  TEST_AMO(1,       amoadd.w,   lw,       0,    x5,   data1, x6,  0xff00ff00, x7,   0x00000000, 0xff00ff00)
  TEST_AMO(2,       amoadd.w,   lw,       0,    x5,   data2, x6,  0x0ff00ff0, x7,   0x00000000, 0x0ff00ff0)
  TEST_AMO(3,       amoadd.w,   lw,       0,    x5,   data3, x6,  0x00ff00ff, x7,   0x00000000, 0x00ff00ff)

  TEST_AMO(4,       amoadd.w,   lw,       0,    x5,   data0, x6,  0x00000f00, x7,   0x00000000, 0x00000f00)
  TEST_AMO(5,       amoadd.w,   lw,       1,    x5,   data0, x6,  0x10000000, x7,   0x00000f00, 0x10000f00)
  TEST_AMO(6,       amoadd.w,   lw,       2,    x5,   data0, x6,  0x00000001, x7,   0x10000f00, 0x10000f01)

  TEST_AMO(7,       amoadd.w,   lw,       4,    x5,   data3, x6,  0x00000100, x7,   0x00ff00ff, 0x00ff01ff)
  TEST_AMO(8,       amoadd.w,   lw,       0,    x5,   data2, x6,  0xf1000000, x7,   0x0ff00ff0, 0x00f00ff0)
  TEST_AMO(9,       amoadd.w,   lw,       0,    x5,   data3, x6,  0xff000000, x7,   0x00ff01ff, 0xffff01ff)

  // ------------------------------
  //          SRC = OTHERS
  // ------------------------------
  TEST_AMO(10,      amoadd.w,   lw,       0,    x10,  data0, x11, 0xf000f000, x12,  0x10000f01, 0x0000ff01)
  TEST_AMO(11,      amoadd.w,   lw,       0,    x13,  data0, x15, 0x00f000f0, x14,  0x0000ff01, 0x00f0fff1)
  TEST_AMO(12,      amoadd.w,   lw,       0,    x16,  data0, x10, 0x000e0000, x7,   0x00f0fff1, 0x00fefff1)
  TEST_AMO(13,      amoadd.w,   lw,       0,    x23,  data1, x24, 0x01000000, x22,  0xff00ff00, 0x0000ff00)

  la x5, data0
  li x6, 0x01
  sw x6, 0(x5)
  li x6, 0x02
  sw x6, 4(x5)
  li x6, 0x03
  sw x6, 8(x5)
  li x6, 0x04
  sw x6, 12(x5)

  // ------------------------------
  //           S2 = DEST
  // ------------------------------
  TEST_AMO(14,      amoadd.w,   lw,       0,    x5,   data0, x6,  0x01,       x7,   0x01,       0x02)
  TEST_AMO(15,      amoadd.w,   lw,       0,    x5,   data0, x6,  0x02,       x7,   0x02,       0x04)

  // ------------------------------
  //            S2 = 0
  // ------------------------------
  TEST_AMO(16,      amoadd.w,   lw,       0,    x5,   data0, x0,  0x02,       x7,   0x04,       0x04)
  TEST_AMO(17,      amoadd.w,   lw,       0,    x5,   data1, x0,  0x01,       x7,   0x02,       0x02)

  // ------------------------------
  //            DEST = 0
  // ------------------------------
  TEST_AMO(18,      amoadd.w,   lw,       0,    x5,   data3, x6,  -0x04,      x0,   0x00,       0x00)
  TEST_AMO(19,      amoadd.w,   lw,       0,    x5,   data3, x6,  0x04,       x0,   0x00,       0x04)

  // ------------------------------
  //         S2 = DEST = 0
  // ------------------------------
  TEST_AMO(20,      amoadd.w,   lw,       0,    x5,   data3, x0,  -0x01,      x0,   0x00,       0x04)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //           testnum, instr_amo,  instr_ld, nnop, rs1,  tbase, rs2, v2,         rd,   vr1,        vr2
  TEST_AMO_BYP(21,      amoadd.w,   lw,       1,    x5,   data2, x6,  0x03,       x7,   0x03,       0x06)
  TEST_AMO_BYP(22,      amoadd.w,   lw,       2,    x5,   data2, x6,  0x01,       x7,   0x06,       0x07)
  TEST_AMO_BYP(23,      amoadd.w,   lw,       4,    x5,   data2, x6,  -0x07,      x7,   0x07,       0x00)
  TEST_AMO_BYP(24,      amoadd.w,   lw,       8,    x5,   data2, x6,  0x01,       x7,   0x00,       0x01)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END

// ******************************
//             DATA
// ******************************
TEST_RODATA

TEST_DATA
data0:  .word 0x00000000
data1:  .word 0x00000000
data2:  .word 0x00000000
data3:  .word 0x00000000
