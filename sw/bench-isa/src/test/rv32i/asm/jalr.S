/*
 * File: jalr.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:34:39 am
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
#define TEST_JALR(testnum, nnop1, nnop2, rs1, rs2, rd) \
start_t##testnum: \
  la rs2, 2f; \
  auipc rs1, 0; \
  INSERT_NOPS_##nnop1; \
1: \
  jalr rd, 0( rs2 ); \
  INSERT_NOPS_##nnop2; \
  li rs1, 0; \
2: \
  sub rd, rd, rs1; \
  TMASK_UP(testnum, rd, 4 * nnop1 + 8);

#define TEST_JALR_OFFSET(testnum, nnop1, nnop2, rs1, rs2, rd) \
start_t##testnum: \
  la rs2, 2f; \
  auipc rs1, 0; \
  INSERT_NOPS_##nnop1; \
1: \
  jalr rd, (4 * nnop2 + 4) ( rs2 ); \
  li rs1, 0; \
2: \
  INSERT_NOPS_##nnop2; \
  li rs1, 0; \
  sub rd, rd, rs1; \
  TMASK_UP(testnum, rd, 4 * nnop1 + 8);

// ******************************
//            INIT
// ******************************
TEST_INIT(19)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //            JUMP
  // ------------------------------
  //        testnum,  nnop1,  nnop2,  rs1,  rs2,  rd
  TEST_JALR(0,        0,      0,      x5,   x6,   x7)
  TEST_JALR(1,        1,      0,      x5,   x6,   x7)
  TEST_JALR(2,        2,      0,      x5,   x6,   x7)
  TEST_JALR(3,        4,      0,      x5,   x6,   x7)
  TEST_JALR(4,        8,      0,      x5,   x6,   x7)
      
  TEST_JALR(5,        0,      1,      x10,  x11,  x12)
  TEST_JALR(6,        0,      2,      x21,  x20,  x19)
  TEST_JALR(7,        0,      8,      x10,  x11,  x13)
  TEST_JALR(8,        0,      16,     x21,  x20,  x22)
  TEST_JALR(9,        8,      32,     x5,   x6,   x7)
  TEST_JALR(10,       8,      48,     x5,   x6,   x7)

  //                testnum,  nnop1,  nnop2,  rs1,  rs2,  rd
  TEST_JALR_OFFSET( 11,       0,      0,      x5,   x6,   x7)
  TEST_JALR_OFFSET( 12,       0,      10,     x5,   x6,   x7)
  TEST_JALR_OFFSET( 13,       1,      10,     x5,   x6,   x7)
  TEST_JALR_OFFSET( 14,       4,      10,     x5,   x6,   x7)
  TEST_JALR_OFFSET( 15,       8,      16,     x5,   x6,   x7)
  TEST_JALR_OFFSET( 16,       4,      2,      x5,   x6,   x7)

  // ------------------------------
  //           DST = 0
  // ------------------------------
start_t17: 
  la x5, 1f
  jalr x0, 0(x5)
  nop
  nop
  nop
1:
  TMASK_UP(17, x0, 0);

  // ------------------------------
  //            DELAY
  // ------------------------------
start_t18:
  la x5, 1f
  li x7, 0
  jr x5
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
  addi x7, x7, 1
1: 
  TMASK_UP(18, x7, 0);
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END