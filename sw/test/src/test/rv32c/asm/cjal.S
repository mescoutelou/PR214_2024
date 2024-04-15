/*
 * File: cjal.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-09-28 06:59:18 pm
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
#define TEST_C_JAL(testnum, nnop1, nnop2, rs1) \
t##testnum##_start: \
  auipc rs1, 0; \
  INSERT_NOPS_##nnop1; \
  c.jal t##testnum##_target; \
  INSERT_NOPS_##nnop2; \
  li rs1, 0; \
t##testnum##_target: \
  sub x1, x1, rs1; \
  TMASK_UP(testnum, x1, 2 * nnop1 + 6);

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
  //          testnum,  nnop1,  nnop2,  rs1,  
  TEST_C_JAL( 0,        0,      0,      x5)   
  TEST_C_JAL( 1,        1,      0,      x5)   
  TEST_C_JAL( 2,        2,      0,      x5)   
  TEST_C_JAL( 3,        4,      0,      x5)   
  TEST_C_JAL( 4,        8,      0,      x5)   
      
  TEST_C_JAL( 5,        0,      1,      x10)  
  TEST_C_JAL( 6,        0,      2,      x21)  
  TEST_C_JAL( 7,        0,      8,      x10)  
  TEST_C_JAL( 8,        0,      16,     x21)  
  TEST_C_JAL( 9,        8,      32,     x5)   
  TEST_C_JAL( 10,       8,      48,     x5)   

  // ------------------------------
  //            DELAY
  // ------------------------------
t11_start:
  li x7, 0
  c.jal t11_target
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