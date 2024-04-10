/*
 * File: auipc.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:34:09 am
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
#define TEST_AUIPC_NOP(testnum, nnop1, nnop2, rs1, rs2, rd) \
start_t##testnum: \
  auipc rs1, 0; \
  INSERT_NOPS_##nnop1; \
  auipc rs2, 0; \
  INSERT_NOPS_##nnop2; \
  sub rd, rs2, rs1; \
  TMASK_UP(testnum, rd, 4 * (nnop1 + 1));

#define TEST_AUIPC_IMM(testnum, nnop, rs1, imm, rs2, rd) \
start_t##testnum: \
  la rs1, 1f + imm; \
  INSERT_NOPS_##nnop; \
1: \
  auipc rs2, 0; \
  sub rd, rs1, rs2; \
  TMASK_UP(testnum, rd, imm);

// ******************************
//            INIT
// ******************************
TEST_INIT(20)

// ******************************
//             BODY
// ******************************
TEST_BODY
  //              testnum,  nnop, nnop2,  rs1,    rs2,  rd
  TEST_AUIPC_NOP( 0,        0,    0,      x5,     x6,   x7) 
  TEST_AUIPC_NOP( 1,        1,    0,      x5,     x6,   x7)
  TEST_AUIPC_NOP( 2,        2,    0,      x5,     x6,   x7)
  TEST_AUIPC_NOP( 3,        4,    0,      x5,     x6,   x7)
  TEST_AUIPC_NOP( 4,        5,    0,      x5,     x6,   x7)
  TEST_AUIPC_NOP( 5,        8,    0,      x5,     x6,   x7)
  TEST_AUIPC_NOP( 6,        0,    1,      x5,     x6,   x7) 
  TEST_AUIPC_NOP( 7,        1,    1,      x5,     x6,   x7)
  TEST_AUIPC_NOP( 8,        1,    2,      x5,     x6,   x7)
  TEST_AUIPC_NOP( 9,        3,    2,      x10,    x11,  x12)
  TEST_AUIPC_NOP( 10,       4,    4,      x15,    x13,  x14)
  TEST_AUIPC_NOP( 11,       8,    8,      x11,    x10,  x10)

  //              testnum,  nnop, rs1,  imm,      rs2,  rd
  TEST_AUIPC_IMM( 12,       0,    x5,   0x0000,   x6,   x7)
  TEST_AUIPC_IMM( 13,       0,    x5,   0x1000,   x6,   x7)
  TEST_AUIPC_IMM( 14,       0,    x5,   -0x1000,  x6,   x7)
  TEST_AUIPC_IMM( 15,       1,    x5,   0x0010,   x6,   x7)
  TEST_AUIPC_IMM( 16,       2,    x5,   0x0010,   x6,   x7)
  TEST_AUIPC_IMM( 17,       4,    x5,   0x0010,   x6,   x7)

start_t18: \
  auipc x0, 0; \
  TMASK_UP(18, x0, 0);

start_t19: \
  auipc x0, 0x1000; \
  TMASK_UP(19, x0, 0);
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
