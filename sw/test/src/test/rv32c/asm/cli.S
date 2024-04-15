/*
 * File: cli.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-09-28 07:09:28 pm
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
TEST_INIT(24)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //           ARITHMETIC
  // ------------------------------

  //            testnum,  instr,  nnop,   rd,   v1,     imm,    vr
  TEST_C_R_IMM( 0,        c.li,   0,      x5,   0x00,   0,      0)
  TEST_C_R_IMM( 1,        c.li,   0,      x5,   0x00,   1,      1)
  TEST_C_R_IMM( 2,        c.li,   0,      x5,   0x00,   8,      8)

  TEST_C_R_IMM( 3,        c.li,   0,      x5,   0x00,   -1,     -1)
  TEST_C_R_IMM( 4,        c.li,   0,      x5,   0x00,   -2,     -2)
  TEST_C_R_IMM( 5,        c.li,   0,      x5,   0x00,   4,      4)

  TEST_C_R_IMM( 6,        c.li,   0,      x5,   0x01,   -1,     -1)
  TEST_C_R_IMM( 7,        c.li,   0,      x5,   0x02,   -1,     -1)
  TEST_C_R_IMM( 8,        c.li,   0,      x5,   0x03,   1,      1)

  TEST_C_R_IMM( 9,        c.li,   0,      x5,   0x00,   31,     31)
  TEST_C_R_IMM( 10,       c.li,   0,      x5,   0x00,   -32,    -32)
  TEST_C_R_IMM( 11,       c.li,   0,      x5,   0x00,   16,     16)

  TEST_C_R_IMM( 12,       c.li,   0,      x10,  0x00,   -1,     -1)
  TEST_C_R_IMM( 13,       c.li,   0,      x13,  0x00,   1,      1)
  TEST_C_R_IMM( 14,       c.li,   0,      x15,  0x00,   -1,     -1)
  TEST_C_R_IMM( 15,       c.li,   0,      x12,  0x00,   -16,    -16) 

  // ------------------------------
  //            BYPASS
  // ------------------------------
  //                testnum,  instr,  nnop,   rs1,  v1,     imm,    vr
  TEST_C_R_IMM_BYP( 16,       c.li,   0,      x5,   0x30,   0x10,   0x10)
  TEST_C_R_IMM_BYP( 17,       c.li,   1,      x5,   0x30,   0x11,   0x11)
  TEST_C_R_IMM_BYP( 18,       c.li,   2,      x5,   0x30,   0x12,   0x12)
  TEST_C_R_IMM_BYP( 19,       c.li,   4,      x5,   0x30,   0x14,   0x14)

  //            testnum,  instr,  nnop,   rd,   v1,     imm,    vr
  TEST_C_R_IMM( 20,       c.li,   1,      x5,   0x20,   0x11,   0x11)
  TEST_C_R_IMM( 21,       c.li,   2,      x5,   0x21,   0x11,   0x11)
  TEST_C_R_IMM( 22,       c.li,   4,      x5,   0x24,   0x12,   0x12)
  TEST_C_R_IMM( 23,       c.li,   8,      x5,   0x28,   0x10,   0x10)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
