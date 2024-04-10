/*
 * File: sb.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:35:36 am
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
  TEST_ST_S12(0,        sb,       lbu,      0,      0,      x5,   data0,    0,        x6,   0xff)
  TEST_ST_S12(1,        sb,       lbu,      0,      0,      x5,   data1,    0,        x6,   0x00)
  TEST_ST_S12(2,        sb,       lbu,      0,      0,      x5,   data2,    0,        x6,   0xf0)
  TEST_ST_S12(3,        sb,       lbu,      0,      0,      x5,   data3,    0,        x6,   0x0f)

  TEST_ST_S12(4,        sb,       lbu,      0,      0,      x5,   data0,    1,        x6,   0x00)
  TEST_ST_S12(5,        sb,       lbu,      0,      0,      x5,   data0,    2,        x6,   0xf0)
  TEST_ST_S12(6,        sb,       lbu,      0,      0,      x5,   data0,    3,        x6,   0x0f)

  TEST_ST_S12(7,        sb,       lbu,      0,      0,      x5,   data1,    -2,       x6,   0xff)
  TEST_ST_S12(8,        sb,       lbu,      0,      0,      x5,   data1,    1,        x6,   0xf0)
  TEST_ST_S12(9,        sb,       lbu,      0,      0,      x5,   data1,    2,        x6,   0x0f)

  TEST_ST_S12(10,       sb,       lbu,      0,      0,      x5,   data2,    -2,       x6,   0xff)
  TEST_ST_S12(11,       sb,       lbu,      0,      0,      x5,   data2,    -1,       x6,   0x00)
  TEST_ST_S12(12,       sb,       lbu,      0,      0,      x5,   data2,    1,        x6,   0x0f)

  // ------------------------------
  //          SRC = OTHERS
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(13,       sb,       lbu,      0,      0,      x10,  data0,    3,        x11,  0xff)
  TEST_ST_S12(14,       sb,       lbu,      0,      0,      x13,  data1,    2,        x15,  0x00)
  TEST_ST_S12(15,       sb,       lbu,      0,      0,      x16,  data2,    1,        x14,  0xf0)
  TEST_ST_S12(16,       sb,       lbu,      0,      0,      x20,  data3,    0,        x10,  0x0f)

  // ------------------------------
  //            SRC = 0
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(17,       sb,       lbu,      0,      0,      x5,   data3,    0,        x0,   0x00)
  TEST_ST_S12(18,       sb,       lbu,      0,      0,      x5,   data1,    1,        x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr_st, instr_ld, nnop1,  nnop2,  rs1,  tbase,    voffset,  rs2,  v2
  TEST_ST_S12(19,       sb,       lbu,      1,      0,      x5,   data0,    0,        x6,   0xff)
  TEST_ST_S12(20,       sb,       lbu,      1,      1,      x5,   data1,    0,        x6,   0x00)
  TEST_ST_S12(21,       sb,       lbu,      1,      2,      x5,   data2,    0,        x6,   0xf0)
  TEST_ST_S12(22,       sb,       lbu,      3,      2,      x5,   data2,    1,        x6,   0xf0)

  TEST_ST_S21(23,       sb,       lbu,      1,      0,      x5,   data3,    0,        x6,   0xff)
  TEST_ST_S21(24,       sb,       lbu,      1,      1,      x5,   data3,    -1,       x6,   0x00)
  TEST_ST_S21(25,       sb,       lbu,      1,      2,      x5,   data3,    -2,       x6,   0xf0)
  TEST_ST_S21(26,       sb,       lbu,      3,      2,      x5,   data3,    -3,       x6,   0xf0)

  //          testnum,  instr_st, instr_ld, nnop,   rs1,  tbase,  voffset,  rs2,  v2,       rd
  TEST_ST_LD( 27,       sb,       lbu,      0,      x5,   data0,  1,        x6,   0xff,     x7)
  TEST_ST_LD( 28,       sb,       lbu,      1,      x5,   data0,  0,        x6,   0xf0,     x7)
  TEST_ST_LD( 29,       sb,       lbu,      4,      x5,   data2,  0,        x6,   0x00,     x7)
  TEST_ST_LD( 30,       sb,       lbu,      8,      x5,   data3,  -2,       x6,   0x0f,     x7)
  TEST_ST_LD( 31,       sb,       lbu,      32,     x5,   data3,  0,        x6,   0xf0,     x7)

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
