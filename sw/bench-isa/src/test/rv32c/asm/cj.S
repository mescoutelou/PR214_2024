/*
 * File: cj.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-03 03:52:04 pm
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
#define TEST_C_J(testnum, nnop1, nnop2, rx) \
t##testnum##_start: \
  li rx, 0x1000; \
  INSERT_NOPS_##nnop1; \
  c.j t##testnum##_target; \
  INSERT_NOPS_##nnop2; \
  li rx, 0; \
t##testnum##_target: \
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
  //        testnum,  nnop1,  nnop2,  rx,  
  TEST_C_J( 0,        0,      0,      x5)   
  TEST_C_J( 1,        1,      0,      x5)   
  TEST_C_J( 2,        2,      0,      x5)   
  TEST_C_J( 3,        4,      0,      x5)   
  TEST_C_J( 4,        8,      0,      x5)   
      
  TEST_C_J( 5,        0,      1,      x10)  
  TEST_C_J( 6,        0,      2,      x21)  
  TEST_C_J( 7,        0,      8,      x10)  
  TEST_C_J( 8,        0,      16,     x21)  
  TEST_C_J( 9,        8,      32,     x5)   
  TEST_C_J( 10,       8,      48,     x5)   

  // ------------------------------
  //            DELAY
  // ------------------------------
t11_start:
  li x7, 0
  c.j t11_target
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
t11_target:
  TMASK_UP(11, x7, 0);
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END