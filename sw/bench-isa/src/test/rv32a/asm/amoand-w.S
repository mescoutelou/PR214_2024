/*
 * File: amoand-w.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-06-13 05:40:52 pm
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
  TEST_AMO(0,       amoand.w,   lw,       0,    x5,   data0, x6,  0x00000000, x7,   0x00000000, 0x00000000)

  TEST_AMO(1,       amoand.w,   lw,       0,    x5,   data1, x6,  0xff00ff00, x7,   0x00000000, 0x00000000)
  TEST_AMO(2,       amoand.w,   lw,       0,    x5,   data2, x6,  0x0ff00ff0, x7,   0x00000000, 0x00000000)
  TEST_AMO(3,       amoand.w,   lw,       0,    x5,   data3, x6,  0x00ff00ff, x7,   0x00000000, 0x00000000)

  la x5, data0
  li x6, 0xff00ff00
  sw x6, 0(x5)
  li x6, 0x0ff00ff0
  sw x6, 4(x5)
  li x6, 0x00ff00ff
  sw x6, 8(x5)
  li x6, 0xf00ff00f
  sw x6, 12(x5)

  TEST_AMO(4,       amoand.w,   lw,       0,    x5,   data0, x6,  0x00000f00, x7,   0xff00ff00, 0x00000f00)
  TEST_AMO(5,       amoand.w,   lw,       1,    x5,   data0, x6,  0x00001a00, x7,   0x00000f00, 0x00000a00)
  TEST_AMO(6,       amoand.w,   lw,       2,    x5,   data0, x6,  0x00000a00, x7,   0x00000a00, 0x00000a00)

  TEST_AMO(7,       amoand.w,   lw,       4,    x5,   data3, x6,  0xfff00fff, x7,   0xf00ff00f, 0xf000000f)
  TEST_AMO(8,       amoand.w,   lw,       0,    x5,   data2, x6,  0xf0000000, x7,   0x00ff00ff, 0x00000000)
  TEST_AMO(9,       amoand.w,   lw,       0,    x5,   data3, x6,  0x0ff00ff0, x7,   0xf000000f, 0x00000000)

  la x5, data0
  li x6, 0xff00ff00
  sw x6, 0(x5)
  li x6, 0x0ff00ff0
  sw x6, 4(x5)
  li x6, 0x00ff00ff
  sw x6, 8(x5)
  li x6, 0xf00ff00f
  sw x6, 12(x5)

  // ------------------------------
  //          SRC = OTHERS
  // ------------------------------
  TEST_AMO(10,      amoand.w,   lw,       0,    x10,  data0, x11, 0xff00f000, x12,  0xff00ff00, 0xff00f000)
  TEST_AMO(11,      amoand.w,   lw,       0,    x13,  data0, x15, 0x0f00f00f, x14,  0xff00f000, 0x0f00f000)
  TEST_AMO(12,      amoand.w,   lw,       0,    x16,  data0, x10, 0x0f000000, x7,   0x0f00f000, 0x0f000000)
  TEST_AMO(13,      amoand.w,   lw,       0,    x23,  data1, x24, 0x01000000, x22,  0x0ff00ff0, 0x01000000)

  // ------------------------------
  //           S2 = DEST
  // ------------------------------
  TEST_AMO(14,      amoand.w,   lw,       0,    x5,   data0, x6,  0x03000000, x7,   0x0f000000, 0x03000000)
  TEST_AMO(15,      amoand.w,   lw,       0,    x5,   data0, x6,  0x02000000, x7,   0x03000000, 0x02000000)

  // ------------------------------
  //            S2 = 0
  // ------------------------------
  TEST_AMO(16,      amoand.w,   lw,       0,    x5,   data0, x0,  0xffffffff, x7,   0x02000000, 0x00000000)
  TEST_AMO(17,      amoand.w,   lw,       0,    x5,   data1, x0,  0x01000000, x7,   0x01000000, 0x00000000)

  // ------------------------------
  //            DEST = 0
  // ------------------------------
  TEST_AMO(18,      amoand.w,   lw,       0,    x5,   data3, x6,  0xf000000f, x0,   0x00000000, 0xf000000f)
  TEST_AMO(19,      amoand.w,   lw,       0,    x5,   data3, x6,  0x0000000f, x0,   0x00000000, 0x0000000f)

  // ------------------------------
  //         S2 = DEST = 0
  // ------------------------------
  TEST_AMO(20,      amoand.w,   lw,       0,    x5,   data3, x0,  0xffffffff, x0,   0x00000000, 0x00000000)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //           testnum, instr_amo,  instr_ld, nnop, rs1,  tbase, rs2, v2,         rd,   vr1,        vr2
  TEST_AMO_BYP(21,      amoand.w,   lw,       1,    x5,   data2, x6,  0x00ff00ff, x7,   0x00ff00ff, 0x00ff00ff)
  TEST_AMO_BYP(22,      amoand.w,   lw,       2,    x5,   data2, x6,  0x000000ff, x7,   0x00ff00ff, 0x000000ff)
  TEST_AMO_BYP(23,      amoand.w,   lw,       4,    x5,   data2, x6,  0xffffffff, x7,   0x000000ff, 0x000000ff)
  TEST_AMO_BYP(24,      amoand.w,   lw,       8,    x5,   data2, x6,  0x12345678, x7,   0x000000ff, 0x00000078)
  
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
