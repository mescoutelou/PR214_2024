/*
 * File: caddi16sp.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-09-29 02:31:48 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "../../../common/macro.h"
#include "../../../common/macro-r.h"


// ******************************
//             MACRO
// ******************************
#define TEST_C_ADDI16SP(testnum, nnop, v1, imm, vr) \
t##testnum##_start: \
  li sp, DATA_XLEN(v1); \
  INSERT_NOPS_##nnop; \
  c.addi16sp sp, imm; \
  TMASK_UP(testnum, sp, vr);

#define TEST_C_ADDI16SP_BYP(testnum, nnop, v1, imm, vr) \
t##testnum##_start: \
  li sp, DATA_XLEN(v1); \
  c.addi16sp sp, imm; \
  INSERT_NOPS_##nnop; \
  mv GPR_W0, sp; \
  TMASK_UP(testnum, GPR_W0, vr);
  
// ******************************
//            INIT
// ******************************
TEST_INIT(15)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //           ARITHMETIC
  // ------------------------------
  //                testnum,  nnop,   v1,     imm,    vr
  TEST_C_ADDI16SP(  0,        0,      0,      16,     16)
  TEST_C_ADDI16SP(  1,        0,      0,      32,     32)
  TEST_C_ADDI16SP(  2,        0,      0,      64,     64)
  TEST_C_ADDI16SP(  3,        0,      10,     -32,    -22)
  TEST_C_ADDI16SP(  4,        0,      1024,   -512,   512)
  TEST_C_ADDI16SP(  5,        0,      0,      128,    128)
  TEST_C_ADDI16SP(  6,        0,      -512,   496,    -16)
  
  // ------------------------------
  //            BYPASS
  // ------------------------------
  //                    testnum,  nnop,   v1,       imm,    vr
  TEST_C_ADDI16SP_BYP(  7,        0,      0x4000,   0x10,   0x4010)
  TEST_C_ADDI16SP_BYP(  8,        1,      512,      -512,   0)
  TEST_C_ADDI16SP_BYP(  9,        2,      0x4008,   0x80,   0x4088)
  TEST_C_ADDI16SP_BYP(  10,       4,      0x4040,   0x90,   0x40d0)

  //                testnum,  nnop,   v1,     imm,    vr
  TEST_C_ADDI16SP(  11,       1,      0x8000, 0x60,   0x8060)
  TEST_C_ADDI16SP(  12,       2,      0x8000, 0x70,   0x8070)
  TEST_C_ADDI16SP(  13,       4,      0x8000, 0x60,   0x8060)
  TEST_C_ADDI16SP(  14,       8,      0x8000, 0x90,   0x8090)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
  la sp, _stack
TEST_END
