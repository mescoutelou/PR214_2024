/*
 * File: sra.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:36:10 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "../../../common/macro.h"
#include "../../../common/macro-rr.h"


// ******************************
//            INIT
// ******************************
TEST_INIT(32)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //           ARITHMETIC
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                 rs2,  v2,   rd,   vr
  TEST_RR_S12(0,        sra,    0,      0,      x5,   0x0000000000000000, x6,   0,    x7,   0x0000000000000000)

  TEST_RR_S12(1,        sra,    0,      0,      x5,   0x800fffff80000000, x6,   0,    x7,   0x800fffff80000000)
  TEST_RR_S12(2,        sra,    0,      0,      x5,   0x800fffff80000000, x6,   1,    x7,   0x4008ffffc0000000)
  TEST_RR_S12(3,        sra,    0,      0,      x5,   0x800fffff80000000, x6,   15,   x7,   0xffff001fffff0000)
  TEST_RR_S12(4,        sra,    0,      0,      x5,   0x800fffff80000000, x6,   16,   x7,   0xffff800fffff8000)
  #if (XLEN == 64)
  TEST_RR_S12(5,        sra,    0,      0,      x5,   0x800fffff80000000, x6,   31,   x7,   0xffffffff001fffff)
  #else
  TEST_RR_S12(5,        sra,    0,      0,      x5,   0x80000000,         x6,   31,   x7,   0xffffffff)
  #endif

  TEST_RR_S12(6,        sra,    0,      0,      x5,   0x4000000040000000, x6,   0,    x7,   0x4000000040000000)
  TEST_RR_S12(7,        sra,    0,      0,      x5,   0x4000000040000000, x6,   1,    x7,   0x2000000020000000)
  TEST_RR_S12(8,        sra,    0,      0,      x5,   0x4000000040000000, x6,   15,   x7,   0x0000800000008000)
  TEST_RR_S12(9,        sra,    0,      0,      x5,   0x4000000040000000, x6,   16,   x7,   0x0000400000004000)
  #if (XLEN == 64)
  TEST_RR_S12(10,       sra,    0,      0,      x5,   0x4000000040000000, x6,   31,   x7,   0x0000000080000000)
  #else
  TEST_RR_S12(10,       sra,    0,      0,      x5,   0x40000000,         x6,   31,   x7,   0x00000000)
  #endif

  #if (XLEN == 64)
  TEST_RR_S12(11,       sra,    0,      0,      x5,   0x8000000000000000, x6,   32,    x7,   0xffffffff80000000)
  TEST_RR_S12(12,       sra,    0,      0,      x10,  0x8000000000000000, x11,  50,    x12,  0xffffffffffffe000)
  TEST_RR_S12(13,       sra,    0,      0,      x13,  0x8000000000000000, x14,  63,    x15,  0xffffffffffffffff)
  TEST_RR_S12(14,       sra,    0,      0,      x12,  0x7fffffffffffffff, x10,  32,    x11,  0x000000007fffffff)
  TEST_RR_S12(15,       sra,    0,      0,      x17,  0x7fffffffffffffff, x10,  63,    x13,  0x0000000000000000)
  #else
  TEST_RR_S12(11,       sra,    0,      0,      x5,   0x80000000,         x6,   32,    x7,   0x80000000)
  TEST_RR_S12(12,       sra,    0,      0,      x10,  0x80000000,         x11,  50,    x12,  0xffffe000)
  TEST_RR_S12(13,       sra,    0,      0,      x13,  0x80000000,         x14,  63,    x15,  0xffffffff)
  TEST_RR_S12(14,       sra,    0,      0,      x12,  0x7fffffff,         x10,  32,    x11,  0x7fffffff)
  TEST_RR_S12(15,       sra,    0,      0,      x17,  0x7fffffff,         x10,  63,    x13,  0x00000000)
  #endif
  

  // ------------------------------
  //          SRC = DEST
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(16,       sra,    0,      0,      x7,   0x20,   x6,   1,      x7,   0x10)
  TEST_RR_S12(17,       sra,    0,      0,      x5,   -0x31,  x7,   2,      x7,   -0x0d)
  TEST_RR_S12(18,       sra,    0,      0,      x7,   0x22,   x7,   3,      x7,   0x00)

  TEST_RR_S21(19,       sra,    0,      0,      x7,   0x30,   x7,   0,      x7,   0x00)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_S12(20,       sra,    0,      0,      x0,   0x20,   x6,   2,      x7,   0x00)
  TEST_RR_S12(21,       sra,    0,      0,      x5,   0x44,   x0,   2,      x7,   0x44)
  TEST_RR_S12(22,       sra,    0,      0,      x0,   0x00,   x0,   3,      x7,   0x00)
  TEST_RR_S12(23,       sra,    0,      0,      x5,   0x30,   x6,   1,      x0,   0x00)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //          testnum,  instr,  nnop,   rs1,  v1,     rs2,  v2,     rd,   vr
  TEST_RR_BYP(24,       sra,    0,      x5,   0x48,   x6,   0,      x10,  0x48)
  TEST_RR_BYP(25,       sra,    1,      x5,   -0x48,  x6,   1,      x10,  -0x24)
  TEST_RR_BYP(26,       sra,    2,      x5,   -0x48,  x6,   2,      x10,  -0x12)
  TEST_RR_BYP(27,       sra,    4,      x5,   0x48,   x6,   3,      x10,  0x09)

  //          testnum,  instr,  nnop1,  nnop2,  rs1,  v1,       rs2,  v2,   rd,   vr
  TEST_RR_S12(28,       sra,    1,      0,      x5,   0x3010,   x6,   4,    x7,   0x0301)
  TEST_RR_S12(29,       sra,    1,      1,      x5,   -0x3010,  x6,   8,    x7,   -0x0031)

  TEST_RR_S21(30,       sra,    1,      0,      x5,   0x3010,   x6,   12,   x7,   0x0003)
  TEST_RR_S21(31,       sra,    1,      1,      x5,   0x9010,   x6,   12,   x7,   0x0009)  
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
