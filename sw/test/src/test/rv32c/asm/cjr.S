/*
 * File: cjr.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-03 03:56:57 pm
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
#define TEST_C_JR(testnum, nnop1, nnop2, rs1, rx) \
start_t##testnum: \
  la rs1, 2f; \
  li rx, 0x1000; \
  INSERT_NOPS_##nnop1; \
1: \
  c.jr rs1; \
  INSERT_NOPS_##nnop2; \
  li rx, 0; \
2: \
  TMASK_UP(testnum, rx, 0x1000);

// ******************************
//            INIT
// ******************************
TEST_INIT(12)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //            JUMP
  // ------------------------------
  //        testnum,  nnop1,  nnop2,  rs1,  rx
  TEST_C_JR(0,        0,      0,      x8,   x9)
  TEST_C_JR(1,        1,      0,      x8,   x9)
  TEST_C_JR(2,        2,      0,      x8,   x9)
  TEST_C_JR(3,        4,      0,      x8,   x9)
  TEST_C_JR(4,        8,      0,      x8,   x9)
      
  TEST_C_JR(5,        0,      1,      x10,  x11)
  TEST_C_JR(6,        0,      2,      x21,  x20)
  TEST_C_JR(7,        0,      8,      x4,   x5)
  TEST_C_JR(8,        0,      16,     x21,  x20)
  TEST_C_JR(9,        8,      32,     x8,   x9)
  TEST_C_JR(10,       8,      48,     x8,   x9)

  // ------------------------------
  //            DELAY
  // ------------------------------
start_t11:
  la x8, 1f
  li x7, 0
  c.jr x8
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
1: 
  TMASK_UP(11, x7, 0);
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END