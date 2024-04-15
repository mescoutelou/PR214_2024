/*
 * File: lh.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:34:53 am
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
  TEST_LD(0,        lh,     0,      x5,   rodata0,  0,        x7,   0x00000000000000ff)
  TEST_LD(1,        lh,     0,      x5,   rodata1,  0,        x7,   0xffffffffffffff00)
  TEST_LD(2,        lh,     0,      x5,   rodata2,  0,        x7,   0x0000000000000ff0)
  TEST_LD(3,        lh,     0,      x5,   rodata3,  0,        x7,   0xfffffffffffff00f)

  TEST_LD(4,        lh,     0,      x5,   rodata0,  2,        x7,   0xffffffffffffff00)
  TEST_LD(5,        lh,     0,      x5,   rodata0,  6,        x7,   0xfffffffffffff00f)
  TEST_LD(6,        lh,     0,      x5,   rodata0,  10,       x7,   0x0000000000007f7f)

  TEST_LD(7,        lh,     0,      x5,   rodata1,  -2,       x7,   0x00000000000000ff)
  TEST_LD(8,        lh,     0,      x5,   rodata1,  2,        x7,   0x0000000000000ff0)
  TEST_LD(9,        lh,     0,      x5,   rodata1,  6,        x7,   0xffffffffffff8080)

  TEST_LD(10,       lh,     0,      x5,   rodata2,  -4,       x7,   0x00000000000000ff)
  TEST_LD(11,       lh,     0,      x5,   rodata2,  -2,       x7,   0xffffffffffffff00)
  TEST_LD(12,       lh,     0,      x5,   rodata2,  2,        x7,   0xfffffffffffff00f)

  TEST_LD(13,       lh,     0,      x13,  rodata2,  -4,       x14,  0x00000000000000ff)
  TEST_LD(14,       lh,     0,      x17,  rodata2,  -2,       x12,  0xffffffffffffff00)
  TEST_LD(15,       lh,     0,      x15,  rodata2,  6,        x16,  0x0000000000007f7f)

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD(16,       lh,     0,      x7,   rodata0,  0,        x7,   0x00000000000000ff)
  TEST_LD(17,       lh,     0,      x7,   rodata0,  2,        x7,   0xffffffffffffff00)
  TEST_LD(18,       lh,     0,      x15,  rodata2,  -2,       x15,  0xffffffffffffff00)
  TEST_LD(19,       lh,     0,      x17,  rodata3,  -6,       x17,  0x00000000000000ff)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD_BYP(20,       lh,     0,      x5,   rodata0,  0,        x7,   0x00000000000000ff)
  TEST_LD_BYP(21,       lh,     1,      x5,   rodata1,  0,        x7,   0xffffffffffffff00)
  TEST_LD_BYP(22,       lh,     2,      x5,   rodata2,  0,        x7,   0x0000000000000ff0)
  TEST_LD_BYP(23,       lh,     4,      x5,   rodata3,  0,        x7,   0xfffffffffffff00f)

  //      testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD(24,       lh,     1,      x5,   rodata1,  0,        x7,   0xffffffffffffff00)
  TEST_LD(25,       lh,     1,      x5,   rodata2,  2,        x7,   0xfffffffffffff00f)
  TEST_LD(26,       lh,     2,      x5,   rodata3,  -6,       x7,   0x00000000000000ff)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END

// ******************************
//             DATA
// ******************************
TEST_RODATA
  rodata0:  .hword 0x00ff
  rodata1:  .hword 0xff00
  rodata2:  .hword 0x0ff0
  rodata3:  .hword 0xf00f
  rodata4:  .hword 0x8080
  rodata5:  .hword 0x7f7f

TEST_DATA
