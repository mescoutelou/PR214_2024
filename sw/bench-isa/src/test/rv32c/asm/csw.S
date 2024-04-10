/*
 * File: csw.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-09-28 02:41:19 pm
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
  TEST_ST_S12(0,        c.sw,     INSTR_LD, 0,      0,      x10,  data0,    0,        x11,  0x00000000)  
  TEST_ST_S12(1,        c.sw,     INSTR_LD, 0,      0,      x10,  data1,    0,        x11,  0xff00ff00)
  TEST_ST_S12(2,        c.sw,     INSTR_LD, 0,      0,      x10,  data2,    0,        x11,  0x0ff00ff0)
  TEST_ST_S12(3,        c.sw,     INSTR_LD, 0,      0,      x10,  data3,    0,        x11,  0xf00ff00f)

  TEST_ST_S12(4,        c.sw,     INSTR_LD, 0,      0,      x10,  data0,    4,        x11,  0xff00ff00)
  TEST_ST_S12(5,        c.sw,     INSTR_LD, 0,      0,      x10,  data0,    8,        x11,  0x0ff00ff0)
  TEST_ST_S12(6,        c.sw,     INSTR_LD, 0,      0,      x10,  data0,    12,       x11,  0xf00ff00f)

  TEST_ST_S12(7,        c.sw,     INSTR_LD, 0,      0,      x10,  data0,    0,        x11,  0x00ff00ff)
  TEST_ST_S12(8,        c.sw,     INSTR_LD, 0,      0,      x10,  data1,    4,        x11,  0x0ff00ff0)
  TEST_ST_S12(9,        c.sw,     INSTR_LD, 0,      0,      x10,  data1,    8,        x11,  0xf00ff00f)
  TEST_ST_S12(10,       c.sw,     INSTR_LD, 0,      0,      x10,  data2,    4,        x11,  0x00ff00ff)

  // ------------------------------
  //          SRC = OTHERS
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(11,       c.sw,     INSTR_LD, 0,      0,      x11,  data0,    12,       x12,  0x00ff00ff)
  TEST_ST_S12(12,       c.sw,     INSTR_LD, 0,      0,      x13,  data1,    8,        x15,  0xff00ff00)
  TEST_ST_S12(13,       c.sw,     INSTR_LD, 0,      0,      x15,  data2,    4,        x14,  0x0ff00ff0)
  TEST_ST_S12(14,       c.sw,     INSTR_LD, 0,      0,      x14,  data3,    0,        x10,  0xf00ff00f)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(15,       c.sw,     INSTR_LD, 1,      0,      x10,  data0,    0,        x11,  0x00ff00ff)
  TEST_ST_S12(16,       c.sw,     INSTR_LD, 1,      1,      x10,  data1,    0,        x11,  0xff00ff00)
  TEST_ST_S12(17,       c.sw,     INSTR_LD, 1,      2,      x10,  data2,    0,        x11,  0x0ff00ff0)
  TEST_ST_S12(18,       c.sw,     INSTR_LD, 3,      2,      x10,  data2,    4,        x11,  0x0ff00ff0)
 
  TEST_ST_S21(19,       c.sw,     INSTR_LD, 1,      0,      x10,  data3,    0,        x11,  0x00ff00ff)
  TEST_ST_S21(20,       c.sw,     INSTR_LD, 1,      1,      x10,  data3,    4,        x11,  0xff00ff00)
  TEST_ST_S21(21,       c.sw,     INSTR_LD, 1,      2,      x10,  data3,    8,        x11,  0x0ff00ff0)
  TEST_ST_S21(22,       c.sw,     INSTR_LD, 3,      2,      x10,  data3,    12,       x11,  0x0ff00ff0)

  //          testnum,  instr_st, instr_ld, nnop,   rs1,  tbase,  voffset,  rs2,  v2,             rd
  TEST_ST_LD( 23,       c.sw,     INSTR_LD, 0,      x10,  data0,  4,        x11,  0x00ff00ff,     x10)
  TEST_ST_LD( 24,       c.sw,     INSTR_LD, 1,      x10,  data0,  0,        x11,  0x0ff00ff0,     x10)
  TEST_ST_LD( 25,       c.sw,     INSTR_LD, 4,      x10,  data2,  0,        x11,  0xff00ff00,     x10)
  TEST_ST_LD( 26,       c.sw,     INSTR_LD, 8,      x10,  data3,  8,        x11,  0xf00ff00f,     x10)
  TEST_ST_LD( 27,       c.sw,     INSTR_LD, 32,     x10,  data3,  0,        x11,  0x0ff00ff0,     x10)

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
