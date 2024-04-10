/*
 * File: lwu.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:35:08 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "../../../common/macro.h"
#include "../../../common/macro-mem.h"


// ******************************
//            INIT
// ******************************
TEST_INIT(27)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //            ACCESS
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD(0,        lw,     0,      x5,   rodata0,  0,        x7,   0x0000000000ff00ff)
  TEST_LD(1,        lw,     0,      x5,   rodata1,  0,        x7,   0x00000000ff00ff00)
  TEST_LD(2,        lw,     0,      x5,   rodata2,  0,        x7,   0x000000000ff00ff0)
  TEST_LD(3,        lw,     0,      x5,   rodata3,  0,        x7,   0x00000000f00ff00f)

  TEST_LD(4,        lw,     0,      x5,   rodata0,  4,        x7,   0x00000000ff00ff00)
  TEST_LD(5,        lw,     0,      x5,   rodata0,  12,       x7,   0x00000000f00ff00f)
  TEST_LD(6,        lw,     0,      x5,   rodata0,  20,       x7,   0x000000007f7f7f7f)

  TEST_LD(7,        lw,     0,      x5,   rodata1,  -4,       x7,   0x0000000000ff00ff)
  TEST_LD(8,        lw,     0,      x5,   rodata1,  4,        x7,   0x000000000ff00ff0)
  TEST_LD(9,        lw,     0,      x5,   rodata1,  12,       x7,   0x0000000080808080)

  TEST_LD(10,       lw,     0,      x5,   rodata2,  -8,       x7,   0x0000000000ff00ff)
  TEST_LD(11,       lw,     0,      x5,   rodata2,  -4,       x7,   0x00000000ff00ff00)
  TEST_LD(12,       lw,     0,      x5,   rodata2,  4,        x7,   0x00000000f00ff00f)

  TEST_LD(13,       lw,     0,      x13,  rodata2,  -8,       x14,  0x0000000000ff00ff)
  TEST_LD(14,       lw,     0,      x17,  rodata2,  -4,       x12,  0x00000000ff00ff00)
  TEST_LD(15,       lw,     0,      x15,  rodata2,  12,       x16,  0x000000007f7f7f7f)

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD(16,       lw,     0,      x7,   rodata0,  0,        x7,   0x0000000000ff00ff)
  TEST_LD(17,       lw,     0,      x7,   rodata0,  4,        x7,   0x00000000ff00ff00)
  TEST_LD(18,       lw,     0,      x15,  rodata2,  -4,       x15,  0x00000000ff00ff00)
  TEST_LD(19,       lw,     0,      x17,  rodata3,  -12,      x17,  0x0000000000ff00ff)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD_BYP(20,       lw,     0,      x5,   rodata0,  0,        x7,   0x0000000000ff00ff)
  TEST_LD_BYP(21,       lw,     1,      x5,   rodata1,  0,        x7,   0x00000000ff00ff00)
  TEST_LD_BYP(22,       lw,     2,      x5,   rodata2,  0,        x7,   0x000000000ff00ff0)
  TEST_LD_BYP(23,       lw,     4,      x5,   rodata3,  0,        x7,   0x00000000f00ff00f)

  //      testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD(24,       lw,     1,      x5,   rodata1,  0,        x7,   0x00000000ff00ff00)
  TEST_LD(25,       lw,     1,      x5,   rodata2,  4,        x7,   0x00000000f00ff00f)
  TEST_LD(26,       lw,     2,      x5,   rodata3,  -12,      x7,   0x0000000000ff00ff)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END

// ******************************
//             DATA
// ******************************
TEST_RODATA
  rodata0:  .word 0x00ff00ff
  rodata1:  .word 0xff00ff00
  rodata2:  .word 0x0ff00ff0
  rodata3:  .word 0xf00ff00f
  rodata4:  .word 0x80808080
  rodata5:  .word 0x7f7f7f7f

TEST_DATA
