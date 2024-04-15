/*
 * File: cbeqz.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-03 12:05:35 pm
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
TEST_INIT(18)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //           COMPARE
  // ------------------------------
  //                  testnum,  instr,  nnop,   rs1,  v1,   rd
  TEST_C_BR_TAKEN(    0,        c.beqz, 0,      x8,   0,    x9)
  TEST_C_BR_TAKEN(    1,        c.beqz, 0,      x9,   0,    x9)

  TEST_C_BR_NOTTAKEN( 2,        c.beqz, 0,      x8,   1,    x9)
  TEST_C_BR_NOTTAKEN( 3,        c.beqz, 0,      x8,   -1,   x9)
  TEST_C_BR_NOTTAKEN( 4,        c.beqz, 0,      x8,   4,    x9)

  TEST_C_BR_TAKEN(    5,        c.beqz, 0,      x14,  0,    x9)
  TEST_C_BR_TAKEN(    6,        c.beqz, 0,      x10,  0,    x13)
  TEST_C_BR_TAKEN(    7,        c.beqz, 0,      x15,  0,    x12) 

  TEST_C_BR_NOTTAKEN( 8,        c.beqz, 0,      x10,  48,   x13)
  TEST_C_BR_NOTTAKEN( 9,        c.beqz, 0,      x14,  4,    x12)

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //                  testnum,  instr,  nnop,   rs1,  v1,   rd
  TEST_C_BR_TAKEN(    10,       c.beqz, 0,      x8,   0,    x9)
  TEST_C_BR_TAKEN(    11,       c.beqz, 1,      x8,   0,    x9)
  TEST_C_BR_TAKEN(    12,       c.beqz, 2,      x8,   0,    x9)
  TEST_C_BR_NOTTAKEN( 13,       c.beqz, 1,      x8,   1,    x9)
  TEST_C_BR_NOTTAKEN( 14,       c.beqz, 2,      x8,   1,    x9)
  TEST_C_BR_NOTTAKEN( 15,       c.beqz, 1,      x8,   1,    x9)

  // ------------------------------
  //            DELAY
  // ------------------------------
start_t16: \
  li x9, 0; \
  li x8, 0; \
  c.beqz x8, 1f; \
  addi x9, x9, 1; \
  addi x9, x9, 1; \
  addi x9, x9, 1; \
  addi x9, x9, 1; \
  addi x9, x9, 1; \
  addi x9, x9, 1; \
  addi x9, x9, 1; \
  addi x9, x9, 1; \
1: \
  TMASK_UP(16, x9, 0);

start_t17: \
  li x9, 0; \
  li x8, 1; \
  c.beqz x8, 1f; \
  addi x9, x9, 1; \
  addi x9, x9, 1; \
  addi x9, x9, 1; \
  addi x9, x9, 1; \
  addi x9, x9, 1; \
  addi x9, x9, 1; \
  addi x9, x9, 1; \
  addi x9, x9, 1; \
1: \
  TMASK_UP(17, x9, 8);
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
