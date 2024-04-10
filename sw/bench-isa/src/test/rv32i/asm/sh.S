/*
 * File: sh.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:35:45 am
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
  TEST_ST_S12(0,        sh,       lhu,      0,      0,      x5,   data0,    0,        x6,   0x0000)
  TEST_ST_S12(1,        sh,       lhu,      0,      0,      x5,   data1,    0,        x6,   0xff00)
  TEST_ST_S12(2,        sh,       lhu,      0,      0,      x5,   data2,    0,        x6,   0x0ff0)
  TEST_ST_S12(3,        sh,       lhu,      0,      0,      x5,   data3,    0,        x6,   0xf00f)

  TEST_ST_S12(4,        sh,       lhu,      0,      0,      x5,   data0,    2,        x6,   0xff00)
  TEST_ST_S12(5,        sh,       lhu,      0,      0,      x5,   data0,    4,        x6,   0x0ff0)
  TEST_ST_S12(6,        sh,       lhu,      0,      0,      x5,   data0,    6,        x6,   0xf00f)

  TEST_ST_S12(7,        sh,       lhu,      0,      0,      x5,   data1,    -2,       x6,   0x00ff)
  TEST_ST_S12(8,        sh,       lhu,      0,      0,      x5,   data1,    2,        x6,   0x0ff0)
  TEST_ST_S12(9,        sh,       lhu,      0,      0,      x5,   data1,    4,        x6,   0xf00f)

  TEST_ST_S12(10,       sh,       lhu,      0,      0,      x5,   data2,    -4,       x6,   0x00ff)
  TEST_ST_S12(11,       sh,       lhu,      0,      0,      x5,   data2,    -2,       x6,   0xff00)
  TEST_ST_S12(12,       sh,       lhu,      0,      0,      x5,   data2,    2,        x6,   0xf00f)

  // ------------------------------
  //          SRC = OTHERS
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(13,       sh,       lhu,      0,      0,      x10,  data0,    6,        x11,  0x00ff)
  TEST_ST_S12(14,       sh,       lhu,      0,      0,      x13,  data1,    4,        x15,  0xff00)
  TEST_ST_S12(15,       sh,       lhu,      0,      0,      x16,  data2,    2,        x14,  0x0ff0)
  TEST_ST_S12(16,       sh,       lhu,      0,      0,      x20,  data3,    0,        x10,  0xf00f)

  // ------------------------------
  //            SRC = 0
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(17,       sh,       lhu,      0,      0,      x5,   data3,    0,        x0,   0x0000)
  TEST_ST_S12(18,       sh,       lhu,      0,      0,      x5,   data1,    2,        x0,   0x0000)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(19,       sh,       lhu,      1,      0,      x5,   data0,    0,        x6,   0x00ff)
  TEST_ST_S12(20,       sh,       lhu,      1,      1,      x5,   data1,    0,        x6,   0xff00)
  TEST_ST_S12(21,       sh,       lhu,      1,      2,      x5,   data2,    0,        x6,   0x0ff0)
  TEST_ST_S12(22,       sh,       lhu,      3,      2,      x5,   data2,    2,        x6,   0x0ff0)

  TEST_ST_S21(23,       sh,       lhu,      1,      0,      x5,   data3,    0,        x6,   0x00ff)
  TEST_ST_S21(24,       sh,       lhu,      1,      1,      x5,   data3,    -2,       x6,   0xff00)
  TEST_ST_S21(25,       sh,       lhu,      1,      2,      x5,   data3,    -4,       x6,   0x0ff0)
  TEST_ST_S21(26,       sh,       lhu,      3,      2,      x5,   data3,    -6,       x6,   0x0ff0)

  //          testnum,  instr_st, instr_ld, nnop,   rs1,  tbase,  voffset,  rs2,  v2,         rd
  TEST_ST_LD( 27,       sh,       lhu,      0,      x5,   data0,  2,        x6,   0x00ff,     x7)
  TEST_ST_LD( 28,       sh,       lhu,      1,      x5,   data0,  0,        x6,   0x0ff0,     x7)
  TEST_ST_LD( 29,       sh,       lhu,      4,      x5,   data2,  0,        x6,   0xff00,     x7)
  TEST_ST_LD( 30,       sh,       lhu,      8,      x5,   data3,  -4,       x6,   0xf00f,     x7)
  TEST_ST_LD( 31,       sh,       lhu,      32,     x5,   data3,  0,        x6,   0x0ff0,     x7)

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
  data0:  .hword 0x0000
  data1:  .hword 0x0000
  data2:  .hword 0x0000
  data3:  .hword 0x0000
