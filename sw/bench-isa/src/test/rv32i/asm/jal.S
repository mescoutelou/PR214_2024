/*
 * File: jal.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-09-28 06:56:02 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "../../../common/macro.h"


// ******************************
//             MACRO
// ******************************
#define TEST_JAL(testnum, nnop1, nnop2, rs1, rd) \
t##testnum##_start: \
  auipc rs1, 0; \
  INSERT_NOPS_##nnop1; \
  jal rd, t##testnum##_target; \
  INSERT_NOPS_##nnop2; \
  li rs1, 0; \
t##testnum##_target: \
  sub rd, rd, rs1; \
  TMASK_UP(testnum, rd, 4 * nnop1 + 8);

// ******************************
//            INIT
// ******************************
TEST_INIT(13)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //            JUMP
  // ------------------------------
  //        testnum,  nnop1,  nnop2,  rs1,  rd
  TEST_JAL( 0,        0,      0,      x5,   x7)
  TEST_JAL( 1,        1,      0,      x5,   x7)
  TEST_JAL( 2,        2,      0,      x5,   x7)
  TEST_JAL( 3,        4,      0,      x5,   x7)
  TEST_JAL( 4,        8,      0,      x5,   x7)
      
  TEST_JAL( 5,        0,      1,      x10,  x11)
  TEST_JAL( 6,        0,      2,      x21,  x20)
  TEST_JAL( 7,        0,      8,      x10,  x11)
  TEST_JAL( 8,        0,      16,     x21,  x20)
  TEST_JAL( 9,        8,      32,     x5,   x7)
  TEST_JAL( 10,       8,      48,     x5,   x7)

  // ------------------------------
  //           DST = 0
  // ------------------------------
t11_start: 
  jal x0, 1f
  nop
  nop
  nop
1:
  TMASK_UP(11, x0, 0);

  // ------------------------------
  //            DELAY
  // ------------------------------
start_t12:
  li x7, 0
  j 1f
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
1:
  TMASK_UP(12, x7, 0);
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END