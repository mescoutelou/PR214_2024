/*
 * File: amomin-w.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-06-13 05:40:36 pm
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
  TEST_AMO(0,       amomin.w,   lw,       0,    x5,   data0, x6,  0x00000000, x7,   0x00000000, 0x00000000)

  TEST_AMO(1,       amomin.w,   lw,       0,    x5,   data1, x6,  0xff00ff00, x7,   0x00000000, 0xff00ff00)
  TEST_AMO(2,       amomin.w,   lw,       0,    x5,   data2, x6,  0x0ff00ff0, x7,   0x00000000, 0x00000000)
  TEST_AMO(3,       amomin.w,   lw,       0,    x5,   data3, x6,  0x00ff00ff, x7,   0x00000000, 0x00000000)

  TEST_AMO(4,       amomin.w,   lw,       0,    x5,   data0, x6,  0x00000001, x7,   0x00000000, 0x00000000)
  TEST_AMO(5,       amomin.w,   lw,       1,    x5,   data0, x6,  0x80000000, x7,   0x00000000, 0x80000000)
  TEST_AMO(6,       amomin.w,   lw,       2,    x5,   data0, x6,  0x000ff001, x7,   0x80000000, 0x80000000)

  TEST_AMO(7,       amomin.w,   lw,       4,    x5,   data3, x6,  0x00000100, x7,   0x00000000, 0x00000000)
  TEST_AMO(8,       amomin.w,   lw,       0,    x5,   data2, x6,  0x0fff0000, x7,   0x00000000, 0x00000000)
  TEST_AMO(9,       amomin.w,   lw,       0,    x5,   data3, x6,  0xf0ff00ff, x7,   0x00000000, 0xf0ff00ff)

  la x5, data0
  li x6, 0x70000000
  sw x0, 0(x5)
  sw x0, 4(x5)
  sw x6, 8(x5)
  sw x6, 12(x5)

  // ------------------------------
  //          SRC = OTHERS
  // ------------------------------
  TEST_AMO(10,      amomin.w,   lw,       0,    x10,  data0, x11, 0x00000001, x12,  0x00000000, 0x00000000)
  TEST_AMO(11,      amomin.w,   lw,       0,    x13,  data0, x15, 0xffffffff, x14,  0x00000000, 0xffffffff)
  TEST_AMO(12,      amomin.w,   lw,       0,    x16,  data0, x10, 0x8000001f, x7,   0xffffffff, 0x8000001f)
  TEST_AMO(13,      amomin.w,   lw,       0,    x23,  data1, x24, 0x10000000, x22,  0x00000000, 0x00000000)

  // ------------------------------
  //           S2 = DEST
  // ------------------------------
  TEST_AMO(14,      amomin.w,   lw,       0,    x5,   data0, x6,  0x00000100, x7,   0x8000001f, 0x8000001f)
  TEST_AMO(15,      amomin.w,   lw,       0,    x5,   data0, x6,  0xf0000000, x7,   0x8000001f, 0x8000001f)

  // ------------------------------
  //            S2 = 0
  // ------------------------------
  TEST_AMO(16,      amomin.w,   lw,       0,    x5,   data0, x0,  0x7fffffff, x7,   0x8000001f, 0x8000001f)
  TEST_AMO(17,      amomin.w,   lw,       0,    x5,   data1, x0,  0x00100000, x7,   0x00000000, 0x00000000)

  // ------------------------------
  //            DEST = 0
  // ------------------------------
  TEST_AMO(18,      amomin.w,   lw,       0,    x5,   data0, x6,  0x11000000, x0,   0x00000000, 0x8000001f)
  TEST_AMO(19,      amomin.w,   lw,       0,    x5,   data0, x6,  0x0f000000, x0,   0x00000000, 0x8000001f)

  // ------------------------------
  //         S2 = DEST = 0
  // ------------------------------
  TEST_AMO(20,      amomin.w,   lw,       0,    x5,   data3, x0,  0xffffffff, x0,   0x00000000, 0x00000000)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //           testnum, instr_amo,  instr_ld, nnop, rs1,  tbase, rs2, v2,         rd,   vr1,        vr2
  TEST_AMO_BYP(21,      amomin.w,   lw,       1,    x5,   data2, x6,  0x00000000, x7,   0x70000000, 0x00000000)
  TEST_AMO_BYP(22,      amomin.w,   lw,       2,    x5,   data2, x6,  0xffffffff, x7,   0x00000000, 0xffffffff)
  TEST_AMO_BYP(23,      amomin.w,   lw,       4,    x5,   data2, x6,  0x00000001, x7,   0xffffffff, 0xffffffff)
  TEST_AMO_BYP(24,      amomin.w,   lw,       8,    x5,   data2, x6,  0xfffffffe, x7,   0xffffffff, 0xfffffffe)
  
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
