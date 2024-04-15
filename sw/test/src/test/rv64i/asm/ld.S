/*
 * File: ld.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:34:50 am
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
  TEST_LD(0,        ld,     0,      x5,   rodata0,  0,        x7,   0x00ff00ff00ff00ff)
  TEST_LD(1,        ld,     0,      x5,   rodata1,  0,        x7,   0xff00ff00ff00ff00)
  TEST_LD(2,        ld,     0,      x5,   rodata2,  0,        x7,   0x0ff00ff00ff00ff0)
  TEST_LD(3,        ld,     0,      x5,   rodata3,  0,        x7,   0xf00ff00ff00ff00f)

  TEST_LD(4,        ld,     0,      x5,   rodata0,  8,        x7,   0xff00ff00ff00ff00)
  TEST_LD(5,        ld,     0,      x5,   rodata0,  16,       x7,   0x0ff00ff00ff00ff0)
  TEST_LD(6,        ld,     0,      x5,   rodata0,  24,       x7,   0xf00ff00ff00ff00f)

  TEST_LD(7,        ld,     0,      x5,   rodata1,  -8,       x7,   0x00ff00ff00ff00ff)
  TEST_LD(8,        ld,     0,      x5,   rodata1,  8,        x7,   0x0ff00ff00ff00ff0)
  TEST_LD(9,        ld,     0,      x5,   rodata1,  16,       x7,   0xf00ff00ff00ff00f)

  TEST_LD(10,       ld,     0,      x5,   rodata2,  -16,      x7,   0x00ff00ff00ff00ff)
  TEST_LD(11,       ld,     0,      x5,   rodata2,  -8,       x7,   0xff00ff00ff00ff00)
  TEST_LD(12,       ld,     0,      x5,   rodata2,  8,        x7,   0xf00ff00ff00ff00f)

  TEST_LD(13,       ld,     0,      x13,  rodata2,  -16,      x14,  0x00ff00ff00ff00ff)
  TEST_LD(14,       ld,     0,      x17,  rodata2,  -8,       x12,  0xff00ff00ff00ff00)
  TEST_LD(15,       ld,     0,      x15,  rodata2,  8,        x16,  0xf00ff00ff00ff00f)

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //      testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD(16,       ld,     0,      x7,   rodata0,  0,        x7,  0x00ff00ff00ff00ff)
  TEST_LD(17,       ld,     0,      x7,   rodata0,  8,        x7,  0xff00ff00ff00ff00)
  TEST_LD(18,       ld,     0,      x15,  rodata2,  -8,       x15, 0xff00ff00ff00ff00)
  TEST_LD(19,       ld,     0,      x17,  rodata3,  -24,      x17, 0x00ff00ff00ff00ff)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD_BYP(20,       ld,     0,      x5,   rodata0,  0,        x7,   0x00ff00ff00ff00ff)
  TEST_LD_BYP(21,       ld,     1,      x5,   rodata1,  0,        x7,   0xff00ff00ff00ff00)
  TEST_LD_BYP(22,       ld,     2,      x5,   rodata2,  0,        x7,   0x0ff00ff00ff00ff0)
  TEST_LD_BYP(23,       ld,     4,      x5,   rodata3,  0,        x7,   0xf00ff00ff00ff00f)

  //      testnum,  instr,  nnop,   rs1,  tbase,    voffset,  rd,   vr
  TEST_LD(24,       ld,     1,      x5,   rodata1,  0,        x7,   0xff00ff00ff00ff00)
  TEST_LD(25,       ld,     1,      x5,   rodata2,  8,        x7,   0xf00ff00ff00ff00f)
  TEST_LD(26,       ld,     2,      x5,   rodata3,  -24,      x7,   0x00ff00ff00ff00ff)
  
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
  rodata0:  .dword 0x00ff00ff00ff00ff
  rodata1:  .dword 0xff00ff00ff00ff00
  rodata2:  .dword 0x0ff00ff00ff00ff0
  rodata3:  .dword 0xf00ff00ff00ff00f
