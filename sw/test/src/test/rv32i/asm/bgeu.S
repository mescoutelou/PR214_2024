/*
 * File: bgeu.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:34:19 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "../../../common/macro.h"
#include "../../../common/macro-br.h"


// ******************************
//            INIT
// ******************************
TEST_INIT(29)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //           COMPARE
  // ------------------------------
  //                    testnum,  instr,  nnop1,  nnop2,  rs1,  v1,                   rs2,  v2,                   rd
  TEST_BR_TAKEN_S12(    0,        bgeu,   0,      0,      x5,   0x0000000000000000,   x6,   0x0000000000000000,   x7)
  TEST_BR_TAKEN_S12(    1,        bgeu,   0,      0,      x5,   0x0000000000000001,   x6,   0x0000000000000000,   x7)
  TEST_BR_TAKEN_S12(    2,        bgeu,   0,      0,      x5,   0x8000000080000000,   x6,   0x0000000000000000,   x7)
  TEST_BR_TAKEN_S12(    3,        bgeu,   0,      0,      x10,  0xffffffffffffffff,   x11,  0xfffffffffffffffe,   x13)
  TEST_BR_TAKEN_S12(    4,        bgeu,   0,      0,      x16,  0xffffffffffff0000,   x15,  0xfffffffffffeffff,   x12) 

  TEST_BR_NOTTAKEN_S12( 5,        bgeu,   0,      0,      x5,   0x0000000000000000,   x6,   0x0000000000000001,   x7)
  TEST_BR_NOTTAKEN_S12( 6,        bgeu,   0,      0,      x5,   0x0000000000000001,   x6,   0x8000000080000000,   x7)
  TEST_BR_NOTTAKEN_S12( 7,        bgeu,   0,      0,      x5,   0xfffffffffffffffe,   x6,   0xffffffffffffffff,   x7)
  TEST_BR_NOTTAKEN_S12( 8,        bgeu,   0,      0,      x10,  0x0000000000000001,   x11,  0x0000000000000002,   x13)
  TEST_BR_NOTTAKEN_S12( 9,        bgeu,   0,      0,      x16,  0xfffffffffffeffff,   x15,  0xffffffffffff0000,   x12)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //                    testnum,  instr,  nnop1,  nnop2,  rs1,  v1,   rs2,  v2,   rd
  TEST_BR_TAKEN_S12(    10,       bgeu,   0,      0,      x0,   -1,   x6,   0,    x7)
  TEST_BR_TAKEN_S12(    11,       bgeu,   0,      0,      x5,   1,    x0,   2,    x7)
  TEST_BR_TAKEN_S12(    12,       bgeu,   0,      0,      x0,   3,    x0,   1,    x7)
  TEST_BR_TAKEN_S12(    13,       bgeu,   0,      0,      x5,   1,    x0,   -1,   x7)

  TEST_BR_NOTTAKEN_S12( 14,       bgeu,   0,      0,      x0,   1,    x6,   1,    x7)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //                    testnum,  instr,  nnop1,  nnop2,  rs1,  v1,   rs2,  v2,   rd
  TEST_BR_TAKEN_S12(    15,       bgeu,   0,      1,      x5,   1,    x6,   1,    x7)
  TEST_BR_TAKEN_S12(    16,       bgeu,   1,      1,      x5,   1,    x6,   1,    x7)
  TEST_BR_TAKEN_S12(    17,       bgeu,   2,      1,      x5,   1,    x6,   1,    x7)
  TEST_BR_NOTTAKEN_S12( 18,       bgeu,   1,      2,      x5,   1,    x6,   2,    x7)
  TEST_BR_NOTTAKEN_S12( 19,       bgeu,   2,      0,      x5,   1,    x6,   2,    x7)
  TEST_BR_NOTTAKEN_S12( 20,       bgeu,   1,      0,      x5,   1,    x6,   2,    x7)

  TEST_BR_TAKEN_S21(    21,       bgeu,   0,      1,      x5,   1,    x6,   0,    x7)
  TEST_BR_TAKEN_S21(    22,       bgeu,   1,      1,      x5,   1,    x6,   0,    x7)
  TEST_BR_TAKEN_S21(    23,       bgeu,   2,      1,      x5,   1,    x6,   0,    x7)
  TEST_BR_NOTTAKEN_S21( 24,       bgeu,   1,      2,      x5,   0,    x6,   1,    x7)
  TEST_BR_NOTTAKEN_S21( 25,       bgeu,   2,      0,      x5,   0,    x6,   1,    x7)
  TEST_BR_NOTTAKEN_S21( 26,       bgeu,   1,      0,      x5,   0,    x6,   1,    x7)

  // ------------------------------
  //            DELAY
  // ------------------------------
start_t27: \
  li x7, 0; \
  li x5, 1; \
  li x6, 0; \
  bgeu x5, x6, 1f; \
  addi x7, x7, 1; \
  addi x7, x7, 1; \
  addi x7, x7, 1; \
  addi x7, x7, 1; \
  addi x7, x7, 1; \
  addi x7, x7, 1; \
  addi x7, x7, 1; \
  addi x7, x7, 1; \
1: \
  TMASK_UP(27, x7, 0);

start_t28: \
  li x7, 0; \
  li x5, 0; \
  li x6, 1; \
  bgeu x5, x6, 1f; \
  addi x7, x7, 1; \
  addi x7, x7, 1; \
  addi x7, x7, 1; \
  addi x7, x7, 1; \
  addi x7, x7, 1; \
  addi x7, x7, 1; \
  addi x7, x7, 1; \
  addi x7, x7, 1; \
1: \
  TMASK_UP(28, x7, 8);
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
