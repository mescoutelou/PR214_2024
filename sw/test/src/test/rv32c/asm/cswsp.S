/*
 * File: cswsp.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-03 02:29:18 pm
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
TEST_INIT(28)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //            ACCESS
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(0,        c.swsp,   INSTR_LD, 0,      0,      x2,   data0,    0,        x11,  0x00000000)  
  TEST_ST_S12(1,        c.swsp,   INSTR_LD, 0,      0,      x2,   data1,    0,        x11,  0xff00ff00)
  TEST_ST_S12(2,        c.swsp,   INSTR_LD, 0,      0,      x2,   data2,    0,        x11,  0x0ff00ff0)
  TEST_ST_S12(3,        c.swsp,   INSTR_LD, 0,      0,      x2,   data3,    0,        x11,  0xf00ff00f)

  TEST_ST_S12(4,        c.swsp,   INSTR_LD, 0,      0,      x2,   data0,    4,        x11,  0xff00ff00)
  TEST_ST_S12(5,        c.swsp,   INSTR_LD, 0,      0,      x2,   data0,    8,        x11,  0x0ff00ff0)
  TEST_ST_S12(6,        c.swsp,   INSTR_LD, 0,      0,      x2,   data0,    12,       x11,  0xf00ff00f)

  TEST_ST_S12(7,        c.swsp,   INSTR_LD, 0,      0,      x2,   data0,    0,        x11,  0x00ff00ff)
  TEST_ST_S12(8,        c.swsp,   INSTR_LD, 0,      0,      x2,   data1,    4,        x11,  0x0ff00ff0)
  TEST_ST_S12(9,        c.swsp,   INSTR_LD, 0,      0,      x2,   data1,    8,        x11,  0xf00ff00f)
  TEST_ST_S12(10,       c.swsp,   INSTR_LD, 0,      0,      x2,   data2,    4,        x11,  0x00ff00ff)

  // ------------------------------
  //          SRC = OTHERS
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(11,       c.swsp,   INSTR_LD, 0,      0,      x2,   data0,    12,       x7,   0x00ff00ff)
  TEST_ST_S12(12,       c.swsp,   INSTR_LD, 0,      0,      x2,   data1,    8,        x15,  0xff00ff00)
  TEST_ST_S12(13,       c.swsp,   INSTR_LD, 0,      0,      x2,   data2,    4,        x14,  0x0ff00ff0)
  TEST_ST_S12(14,       c.swsp,   INSTR_LD, 0,      0,      x2,   data3,    0,        x19,  0xf00ff00f)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(15,       c.swsp,   INSTR_LD, 1,      0,      x2,   data0,    0,        x11,  0x00ff00ff)
  TEST_ST_S12(16,       c.swsp,   INSTR_LD, 1,      1,      x2,   data1,    0,        x11,  0xff00ff00)
  TEST_ST_S12(17,       c.swsp,   INSTR_LD, 1,      2,      x2,   data2,    0,        x11,  0x0ff00ff0)
  TEST_ST_S12(18,       c.swsp,   INSTR_LD, 3,      2,      x2,   data2,    4,        x11,  0x0ff00ff0)
 
  TEST_ST_S21(19,       c.swsp,   INSTR_LD, 1,      0,      x2,   data3,    0,        x11,  0x00ff00ff)
  TEST_ST_S21(20,       c.swsp,   INSTR_LD, 1,      1,      x2,   data3,    4,        x11,  0xff00ff00)
  TEST_ST_S21(21,       c.swsp,   INSTR_LD, 1,      2,      x2,   data3,    8,        x11,  0x0ff00ff0)
  TEST_ST_S21(22,       c.swsp,   INSTR_LD, 3,      2,      x2,   data3,    12,       x11,  0x0ff00ff0)

  //          testnum,  instr_st, instr_ld, nnop,   rs1,  tbase,  voffset,  rs2,  v2,             rd
  TEST_ST_LD( 23,       c.swsp,   INSTR_LD, 0,      x2,   data0,  4,        x11,  0x00ff00ff,     x10)
  TEST_ST_LD( 24,       c.swsp,   INSTR_LD, 1,      x2,   data0,  0,        x11,  0x0ff00ff0,     x10)
  TEST_ST_LD( 25,       c.swsp,   INSTR_LD, 4,      x2,   data2,  0,        x11,  0xff00ff00,     x10)
  TEST_ST_LD( 26,       c.swsp,   INSTR_LD, 8,      x2,   data3,  8,        x11,  0xf00ff00f,     x10)
  TEST_ST_LD( 27,       c.swsp,   INSTR_LD, 32,     x2,   data3,  0,        x11,  0x0ff00ff0,     x10)

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
  data4:  .word 0x00000000
  data5:  .word 0x00000000
  data6:  .word 0x00000000
  data7:  .word 0x00000000
