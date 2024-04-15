/*
 * File: clui.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-09-29 02:30:04 pm
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
#define TEST_C_LUI(testnum, nnop, rd, imm, vr) \
t##testnum##_start: \
  c.lui rd, imm; \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, vr);

// ******************************
//            INIT
// ******************************
TEST_INIT(10)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //           ARITHMETIC
  // ------------------------------
  //          testnum,  nnop,   rd,   imm,      vr
  TEST_C_LUI( 0,        0,      x5,   0x00001,  0x0000000000001000)
  TEST_C_LUI( 1,        0,      x5,   0x0001f,  0x000000000001f000)
  TEST_C_LUI( 2,        0,      x5,   0xfffe0,  0xfffffffffffe0000)

  TEST_C_LUI( 3,        0,      x5,   0x00002,  0x0000000000002000)
  TEST_C_LUI( 4,        0,      x5,   0xffff0,  0xffffffffffff0000)
  TEST_C_LUI( 5,        0,      x5,   0x0000f,  0x000000000000f000)

  TEST_C_LUI( 6,        0,      x10,  0x00001,  0x0000000000001000)
  TEST_C_LUI( 7,        0,      x13,  0xffff0,  0xffffffffffff0000)
  TEST_C_LUI( 8,        0,      x15,  0xfffe0,  0xfffffffffffe0000)
  TEST_C_LUI( 9,        0,      x12,  0x0000a,  0x000000000000a000)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
