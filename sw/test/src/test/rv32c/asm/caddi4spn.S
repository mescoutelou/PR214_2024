/*
 * File: caddi4spn.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-09-28 02:41:48 pm
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
//            INIT
// ******************************
TEST_INIT(13)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //           ARITHMETIC
  // ------------------------------
  //          testnum,  instr,        nnop,   rs1,  v1,                   imm,    rd,   vr
  TEST_R_IMM( 0,        c.addi4spn,   0,      sp,   0x0000000000080000,   0x04,   x10,  0x0000000000080004)
  TEST_R_IMM( 1,        c.addi4spn,   0,      sp,   0x0000000000080000,   0x08,   x11,  0x0000000000080008)
  TEST_R_IMM( 2,        c.addi4spn,   0,      sp,   0x0000000000080010,   0x10,   x11,  0x0000000000080020)
  TEST_R_IMM( 3,        c.addi4spn,   0,      sp,   0x0000000000080000,   0x40,   x15,  0x0000000000080040)
  TEST_R_IMM( 4,        c.addi4spn,   0,      sp,   0x0000000000100000,   0x40,   x14,  0x0000000000100040)
  
  // ------------------------------
  //            BYPASS
  // ------------------------------
  //              testnum,  instr,        nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM_BYP( 5,        c.addi4spn,   0,      sp,   0x4000, 0x10,   x10,  0x4010)
  TEST_R_IMM_BYP( 6,        c.addi4spn,   1,      sp,   0x4004, 0x04,   x10,  0x4008)
  TEST_R_IMM_BYP( 7,        c.addi4spn,   2,      sp,   0x4008, 0x18,   x10,  0x4020)
  TEST_R_IMM_BYP( 8,        c.addi4spn,   4,      sp,   0x4040, 0x14,   x10,  0x4054)

  //          testnum,  instr,        nnop,   rs1,  v1,     imm,    rd,   vr
  TEST_R_IMM( 9,        c.addi4spn,   1,      sp,   0x4000, 0x20,   x10,  0x4020)
  TEST_R_IMM( 10,       c.addi4spn,   2,      sp,   0x4000, 0x20,   x10,  0x4020)
  TEST_R_IMM( 11,       c.addi4spn,   4,      sp,   0x4000, 0x24,   x10,  0x4024)
  TEST_R_IMM( 12,       c.addi4spn,   8,      sp,   0x4000, 0x30,   x10,  0x4030)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
  la sp, _stack
TEST_END
