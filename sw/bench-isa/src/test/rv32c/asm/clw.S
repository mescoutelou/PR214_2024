/*
 * File: clw.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-09-28 02:41:40 pm
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
TEST_INIT(22)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //            ACCESS
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD(0,        c.lw,   0,      x10,  rodata0,  0,        x11,  0x0000000000ff00ff)
  TEST_LD(1,        c.lw,   0,      x10,  rodata1,  0,        x11,  0xffffffffff00ff00)
  TEST_LD(2,        c.lw,   0,      x10,  rodata2,  0,        x11,  0x000000000ff00ff0)
  TEST_LD(3,        c.lw,   0,      x10,  rodata3,  0,        x11,  0xfffffffff00ff00f)

  TEST_LD(4,        c.lw,   0,      x10,  rodata0,  4,        x11,  0xffffffffff00ff00)
  TEST_LD(5,        c.lw,   0,      x10,  rodata0,  12,       x11,  0xfffffffff00ff00f)
  TEST_LD(6,        c.lw,   0,      x10,  rodata0,  20,       x11,  0x000000007f7f7f7f)

  TEST_LD(7,        c.lw,   0,      x11,  rodata1,  8,        x12,  0xfffffffff00ff00f)
  TEST_LD(8,        c.lw,   0,      x15,  rodata1,  4,        x10,  0x000000000ff00ff0)
  TEST_LD(9,        c.lw,   0,      x12,  rodata0,  12,       x13,  0xfffffffff00ff00f)
  TEST_LD(10,       c.lw,   0,      x11,  rodata2,  8,        x14,  0xffffffff80808080)

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD(11,       c.lw,   0,      x10,  rodata0,  0,        x10,  0x0000000000ff00ff)
  TEST_LD(12,       c.lw,   0,      x10,  rodata0,  4,        x10,  0xffffffffff00ff00)
  TEST_LD(13,       c.lw,   0,      x15,  rodata2,  4,        x15,  0xfffffffff00ff00f)
  TEST_LD(14,       c.lw,   0,      x13,  rodata3,  8,        x13,  0x000000007f7f7f7f)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD_BYP(15,       c.lw,   0,      x10,  rodata0,  0,        x11,  0x0000000000ff00ff)
  TEST_LD_BYP(16,       c.lw,   1,      x10,  rodata1,  0,        x11,  0xffffffffff00ff00)
  TEST_LD_BYP(17,       c.lw,   2,      x10,  rodata2,  0,        x11,  0x000000000ff00ff0)
  TEST_LD_BYP(18,       c.lw,   4,      x10,  rodata3,  0,        x11,  0xfffffffff00ff00f)

  //      testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD(19,       c.lw,   1,      x10,  rodata1,  0,        x11,  0xffffffffff00ff00)
  TEST_LD(20,       c.lw,   1,      x10,  rodata2,  4,        x11,  0xfffffffff00ff00f)
  TEST_LD(21,       c.lw,   2,      x10,  rodata3,  8,        x11,  0x000000007f7f7f7f)

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
