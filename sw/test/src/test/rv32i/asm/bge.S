/*
 * File: bge.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:34:16 am
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
  //                    testnum,  instr,  nnop1,  nnop2,  rs1,  v1,   rs2,  v2,   rd
  TEST_BR_TAKEN_S12(    0,        bge,    0,      0,      x5,   0,    x6,   0,    x7)
  TEST_BR_TAKEN_S12(    1,        bge,    0,      0,      x5,   1,    x6,   0,    x7)
  TEST_BR_TAKEN_S12(    2,        bge,    0,      0,      x5,   -1,   x6,   -1,   x7)
  TEST_BR_TAKEN_S12(    3,        bge,    0,      0,      x10,  48,   x11,  47,   x13)
  TEST_BR_TAKEN_S12(    4,        bge,    0,      0,      x16,  -10,  x15,  -11,  x12) 

  TEST_BR_NOTTAKEN_S12( 5,        bge,    0,      0,      x5,   0,    x6,   1,    x7)
  TEST_BR_NOTTAKEN_S12( 6,        bge,    0,      0,      x5,   -1,   x6,   1,    x7)
  TEST_BR_NOTTAKEN_S12( 7,        bge,    0,      0,      x5,   -2,   x6,   -1,   x7)
  TEST_BR_NOTTAKEN_S12( 8,        bge,    0,      0,      x10,  47,   x11,  48,   x13)
  TEST_BR_NOTTAKEN_S12( 9,        bge,    0,      0,      x16,  -4,   x15,  4,    x12)

  // ------------------------------
  //          SRC = 0
  // ------------------------------
  //                    testnum,  instr,  nnop1,  nnop2,  rs1,  v1,   rs2,  v2,   rd
  TEST_BR_TAKEN_S12(    10,       bge,    0,      0,      x0,   -1,   x6,   0,    x7)
  TEST_BR_TAKEN_S12(    11,       bge,    0,      0,      x5,   1,    x0,   2,    x7)
  TEST_BR_TAKEN_S12(    12,       bge,    0,      0,      x0,   3,    x0,   1,    x7)

  TEST_BR_NOTTAKEN_S12( 13,       bge,    0,      0,      x0,   1,    x6,   1,    x7)
  TEST_BR_NOTTAKEN_S12( 14,       bge,    0,      0,      x5,   -1,   x0,   1,    x7)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //                    testnum,  instr,  nnop1,  nnop2,  rs1,  v1,   rs2,  v2,   rd
  TEST_BR_TAKEN_S12(    15,       bge,    0,      1,      x5,   1,    x6,   1,    x7)
  TEST_BR_TAKEN_S12(    16,       bge,    1,      1,      x5,   1,    x6,   1,    x7)
  TEST_BR_TAKEN_S12(    17,       bge,    2,      1,      x5,   1,    x6,   1,    x7)
  TEST_BR_NOTTAKEN_S12( 18,       bge,    1,      2,      x5,   1,    x6,   2,    x7)
  TEST_BR_NOTTAKEN_S12( 19,       bge,    2,      0,      x5,   1,    x6,   2,    x7)
  TEST_BR_NOTTAKEN_S12( 20,       bge,    1,      0,      x5,   1,    x6,   2,    x7)

  TEST_BR_TAKEN_S21(    21,       bge,    0,      1,      x5,   1,    x6,   0,    x7)
  TEST_BR_TAKEN_S21(    22,       bge,    1,      1,      x5,   1,    x6,   0,    x7)
  TEST_BR_TAKEN_S21(    23,       bge,    2,      1,      x5,   1,    x6,   0,    x7)
  TEST_BR_NOTTAKEN_S21( 24,       bge,    1,      2,      x5,   0,    x6,   1,    x7)
  TEST_BR_NOTTAKEN_S21( 25,       bge,    2,      0,      x5,   0,    x6,   1,    x7)
  TEST_BR_NOTTAKEN_S21( 26,       bge,    1,      0,      x5,   0,    x6,   1,    x7)

  // ------------------------------
  //            DELAY
  // ------------------------------
start_t27: \
  li x7, 0; \
  li x5, 1; \
  li x6, 0; \
  bge x5, x6, 1f; \
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
  bge x5, x6, 1f; \
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
