/*
 * File: sd.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:35:41 am
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
TEST_INIT(32)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //            ACCESS
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(0,        sd,       ld,       0,      0,      x5,   data0,    0,        x6,   0x0000000000000000)
  
  TEST_ST_S12(1,        sd,       ld,       0,      0,      x5,   data1,    0,        x6,   0xff00ff00ff00ff00)
  TEST_ST_S12(2,        sd,       ld,       0,      0,      x5,   data2,    0,        x6,   0x0ff00ff00ff00ff0)
  TEST_ST_S12(3,        sd,       ld,       0,      0,      x5,   data3,    0,        x6,   0xf00ff00ff00ff00f)

  TEST_ST_S12(4,        sd,       ld,       0,      0,      x5,   data0,    8,        x6,   0xff00ff00ff00ff00)
  TEST_ST_S12(5,        sd,       ld,       0,      0,      x5,   data0,    16,       x6,   0x0ff00ff00ff00ff0)
  TEST_ST_S12(6,        sd,       ld,       0,      0,      x5,   data0,    24,       x6,   0xf00ff00ff00ff00f)

  TEST_ST_S12(7,        sd,       ld,       0,      0,      x5,   data1,    -8,       x6,   0x00ff00ff00ff00ff)
  TEST_ST_S12(8,        sd,       ld,       0,      0,      x5,   data1,    8,        x6,   0x0ff00ff00ff00ff0)
  TEST_ST_S12(9,        sd,       ld,       0,      0,      x5,   data1,    16,       x6,   0xf00ff00ff00ff00f)

  TEST_ST_S12(10,       sd,       ld,       0,      0,      x5,   data2,    -16,      x6,   0x00ff00ff00ff00ff)
  TEST_ST_S12(11,       sd,       ld,       0,      0,      x5,   data2,    -8,       x6,   0xff00ff00ff00ff00)
  TEST_ST_S12(12,       sd,       ld,       0,      0,      x5,   data2,    8,        x6,   0xf00ff00ff00ff00f)

  // ------------------------------
  //          SRC = OTHERS
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(13,       sd,       ld,       0,      0,      x10,  data0,    24,       x11,  0x00ff00ff00ff00ff)
  TEST_ST_S12(14,       sd,       ld,       0,      0,      x13,  data1,    16,       x15,  0xff00ff00ff00ff00)
  TEST_ST_S12(15,       sd,       ld,       0,      0,      x16,  data2,    8,        x14,  0x0ff00ff00ff00ff0)
  TEST_ST_S12(16,       sd,       ld,       0,      0,      x20,  data3,    0,        x10,  0xf00ff00ff00ff00f)

  // ------------------------------
  //            SRC = 0
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(17,       sd,       ld,       0,      0,      x5,   data3,    0,        x0,   0x0000000000000000)
  TEST_ST_S12(18,       sd,       ld,       0,      0,      x5,   data1,    8,        x0,   0x0000000000000000)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(19,       sd,       ld,       1,      0,      x5,   data0,    0,        x6,   0x00ff00ff00ff00ff)
  TEST_ST_S12(20,       sd,       ld,       1,      1,      x5,   data1,    0,        x6,   0xff00ff00ff00ff00)
  TEST_ST_S12(21,       sd,       ld,       1,      2,      x5,   data2,    0,        x6,   0x0ff00ff00ff00ff0)
  TEST_ST_S12(22,       sd,       ld,       3,      2,      x5,   data2,    8,        x6,   0x0ff00ff00ff00ff0)

  TEST_ST_S21(23,       sd,       ld,       1,      0,      x5,   data3,    0,        x6,   0x00ff00ff00ff00ff)
  TEST_ST_S21(24,       sd,       ld,       1,      1,      x5,   data3,    -8,       x6,   0xff00ff00ff00ff00)
  TEST_ST_S21(25,       sd,       ld,       1,      2,      x5,   data3,    -16,      x6,   0x0ff00ff00ff00ff0)
  TEST_ST_S21(26,       sd,       ld,       3,      2,      x5,   data3,    -24,      x6,   0x0ff00ff00ff00ff0)

  //          testnum,  instr_st, instr_ld, nnop,   rs1,  tbase,  voffset,  rs2,  v2,                     rd
  TEST_ST_LD( 27,       sd,       ld,       0,      x5,   data0,  8,        x6,   0x00ff00ff00ff00ff,     x7)
  TEST_ST_LD( 28,       sd,       ld,       1,      x5,   data0,  0,        x6,   0x0ff00ff00ff00ff0,     x7)
  TEST_ST_LD( 29,       sd,       ld,       4,      x5,   data2,  0,        x6,   0xff00ff00ff00ff00,     x7)
  TEST_ST_LD( 30,       sd,       ld,       8,      x5,   data3,  -16,      x6,   0xf00ff00ff00ff00f,     x7)
  TEST_ST_LD( 31,       sd,       ld,       32,     x5,   data3,  0,        x6,   0x0ff00ff00ff00ff0,     x7)

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
  data0:  .dword 0x0000000000000000
  data1:  .dword 0x0000000000000000
  data2:  .dword 0x0000000000000000
  data3:  .dword 0x0000000000000000
