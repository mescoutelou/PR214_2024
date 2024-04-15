/*
 * File: lbu.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:34:47 am
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
  TEST_LD(0,        lbu,    0,      x5,   rodata0,  0,        x7,   0x00000000000000ff)
  TEST_LD(1,        lbu,    0,      x5,   rodata1,  0,        x7,   0x0000000000000000)
  TEST_LD(2,        lbu,    0,      x5,   rodata2,  0,        x7,   0x00000000000000f0)
  TEST_LD(3,        lbu,    0,      x5,   rodata3,  0,        x7,   0x000000000000000f)

  TEST_LD(4,        lbu,    0,      x5,   rodata0,  1,        x7,   0x0000000000000000)
  TEST_LD(5,        lbu,    0,      x5,   rodata0,  3,        x7,   0x000000000000000f)
  TEST_LD(6,        lbu,    0,      x5,   rodata0,  5,        x7,   0x000000000000007f)

  TEST_LD(7,        lbu,    0,      x5,   rodata1,  -1,       x7,   0x00000000000000ff)
  TEST_LD(8,        lbu,    0,      x5,   rodata1,  1,        x7,   0x00000000000000f0)
  TEST_LD(9,        lbu,    0,      x5,   rodata1,  3,        x7,   0x0000000000000080)

  TEST_LD(10,       lbu,    0,      x5,   rodata2,  -2,       x7,   0x00000000000000ff)
  TEST_LD(11,       lbu,    0,      x5,   rodata2,  -1,       x7,   0x0000000000000000)
  TEST_LD(12,       lbu,    0,      x5,   rodata2,  1,        x7,   0x000000000000000f)

  TEST_LD(13,       lbu,    0,      x13,  rodata2,  -2,       x14,  0x00000000000000ff)
  TEST_LD(14,       lbu,    0,      x17,  rodata2,  -1,       x12,  0x0000000000000000)
  TEST_LD(15,       lbu,    0,      x15,  rodata2,  3,        x16,  0x000000000000007f)

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD(16,       lbu,    0,      x7,   rodata0,  0,        x7,   0x00000000000000ff)
  TEST_LD(17,       lbu,    0,      x7,   rodata0,  1,        x7,   0x0000000000000000)
  TEST_LD(18,       lbu,    0,      x15,  rodata2,  -1,       x15,  0x0000000000000000)
  TEST_LD(19,       lbu,    0,      x17,  rodata3,  -3,       x17,  0x00000000000000ff)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD_BYP(20,       lbu,    0,      x5,   rodata0,  0,        x7,   0x00000000000000ff)
  TEST_LD_BYP(21,       lbu,    1,      x5,   rodata1,  0,        x7,   0x0000000000000000)
  TEST_LD_BYP(22,       lbu,    2,      x5,   rodata2,  0,        x7,   0x00000000000000f0)
  TEST_LD_BYP(23,       lbu,    4,      x5,   rodata3,  0,        x7,   0x000000000000000f)

  //      testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD(24,       lbu,    1,      x5,   rodata1,  0,        x7,   0x0000000000000000)
  TEST_LD(25,       lbu,    1,      x5,   rodata2,  1,        x7,   0x000000000000000f)
  TEST_LD(26,       lbu,    2,      x5,   rodata3,  -3,       x7,   0x00000000000000ff)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END

// ******************************
//             DATA
// ******************************
TEST_RODATA
  rodata0:  .byte 0xff
  rodata1:  .byte 0x00
  rodata2:  .byte 0xf0
  rodata3:  .byte 0x0f
  rodata4:  .byte 0x80
  rodata5:  .byte 0x7f

TEST_DATA
