/*
 * File: sw.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-03-04 10:46:57 am
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
//            MACRO
// ******************************
#if (XLEN >= 64)
  #define INSTR_LD lwu
#else
  #define INSTR_LD lw
#endif

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
  TEST_ST_S12(0,        sw,       INSTR_LD, 0,      0,      x5,   data0,    0,        x6,   0x00000000)
  
  TEST_ST_S12(1,        sw,       INSTR_LD, 0,      0,      x5,   data1,    0,        x6,   0xff00ff00)
  TEST_ST_S12(2,        sw,       INSTR_LD, 0,      0,      x5,   data2,    0,        x6,   0x0ff00ff0)
  TEST_ST_S12(3,        sw,       INSTR_LD, 0,      0,      x5,   data3,    0,        x6,   0xf00ff00f)

  TEST_ST_S12(4,        sw,       INSTR_LD, 0,      0,      x5,   data0,    4,        x6,   0xff00ff00)
  TEST_ST_S12(5,        sw,       INSTR_LD, 0,      0,      x5,   data0,    8,        x6,   0x0ff00ff0)
  TEST_ST_S12(6,        sw,       INSTR_LD, 0,      0,      x5,   data0,    12,       x6,   0xf00ff00f)

  TEST_ST_S12(7,        sw,       INSTR_LD, 0,      0,      x5,   data1,    -4,       x6,   0x00ff00ff)
  TEST_ST_S12(8,        sw,       INSTR_LD, 0,      0,      x5,   data1,    4,        x6,   0x0ff00ff0)
  TEST_ST_S12(9,        sw,       INSTR_LD, 0,      0,      x5,   data1,    8,        x6,   0xf00ff00f)

  TEST_ST_S12(10,       sw,       INSTR_LD, 0,      0,      x5,   data2,    -8,       x6,   0x00ff00ff)
  TEST_ST_S12(11,       sw,       INSTR_LD, 0,      0,      x5,   data2,    -4,       x6,   0xff00ff00)
  TEST_ST_S12(12,       sw,       INSTR_LD, 0,      0,      x5,   data2,    4,        x6,   0xf00ff00f)

  // ------------------------------
  //          SRC = OTHERS
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(13,       sw,       INSTR_LD, 0,      0,      x10,  data0,    12,       x11,  0x00ff00ff)
  TEST_ST_S12(14,       sw,       INSTR_LD, 0,      0,      x13,  data1,    8,        x15,  0xff00ff00)
  TEST_ST_S12(15,       sw,       INSTR_LD, 0,      0,      x16,  data2,    4,        x14,  0x0ff00ff0)
  TEST_ST_S12(16,       sw,       INSTR_LD, 0,      0,      x20,  data3,    0,        x10,  0xf00ff00f)

  // ------------------------------
  //            SRC = 0
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(17,       sw,       INSTR_LD, 0,      0,      x5,   data3,    0,        x0,   0x00000000)
  TEST_ST_S12(18,       sw,       INSTR_LD, 0,      0,      x5,   data1,    4,        x0,   0x00000000)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(19,       sw,       INSTR_LD, 1,      0,      x5,   data0,    0,        x6,   0x00ff00ff)
  TEST_ST_S12(20,       sw,       INSTR_LD, 1,      1,      x5,   data1,    0,        x6,   0xff00ff00)
  TEST_ST_S12(21,       sw,       INSTR_LD, 1,      2,      x5,   data2,    0,        x6,   0x0ff00ff0)
  TEST_ST_S12(22,       sw,       INSTR_LD, 3,      2,      x5,   data2,    4,        x6,   0x0ff00ff0)

  TEST_ST_S21(23,       sw,       INSTR_LD, 1,      0,      x5,   data3,    0,        x6,   0x00ff00ff)
  TEST_ST_S21(24,       sw,       INSTR_LD, 1,      1,      x5,   data3,    -4,       x6,   0xff00ff00)
  TEST_ST_S21(25,       sw,       INSTR_LD, 1,      2,      x5,   data3,    -8,       x6,   0x0ff00ff0)
  TEST_ST_S21(26,       sw,       INSTR_LD, 3,      2,      x5,   data3,    -12,      x6,   0x0ff00ff0)

  //          testnum,  instr_st, instr_ld, nnop,   rs1,  tbase,  voffset,  rs2,  v2,             rd
  TEST_ST_LD( 27,       sw,       INSTR_LD, 0,      x5,   data0,  4,        x6,   0x00ff00ff,     x7)
  TEST_ST_LD( 28,       sw,       INSTR_LD, 1,      x5,   data0,  0,        x6,   0x0ff00ff0,     x7)
  TEST_ST_LD( 29,       sw,       INSTR_LD, 4,      x5,   data2,  0,        x6,   0xff00ff00,     x7)
  TEST_ST_LD( 30,       sw,       INSTR_LD, 8,      x5,   data3,  -8,       x6,   0xf00ff00f,     x7)
  TEST_ST_LD( 31,       sw,       INSTR_LD, 32,     x5,   data3,  0,        x6,   0x0ff00ff0,     x7)

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
