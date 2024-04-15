/*
 * File: fadds.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2024-04-15 12:30:46 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2024 HerdWare
 * -----
 * Description: 
 */


#include "../../../common/macro.h"
#include "../../../common/macro-f.h"


// ******************************
//            INIT
// ******************************
TEST_INIT(3)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //           ARITHMETIC
  // ------------------------------
  //          testnum,  instr,    nnop1,  nnop2,  fs1,  v1,                 fs2,  v2,                 fd,   vr
  TEST_F_S12( 0,        fadd.s,   0,      0,      f5,   V32_P0_0000,        f6,   V32_P0_0000,        f7,   V32_P0_0000)
  TEST_F_S12( 1,        fadd.s,   0,      0,      f5,   V32_P0_5000,        f6,   V32_P0_5000,        f7,   V32_P1_0000)
  TEST_F_S12( 2,        fadd.s,   0,      0,      f5,   V32_P1_5000,        f6,   V32_P0_5000,        f7,   V32_P2_0000)
  
  // ------------------------------
  //          SRC = DEST
  // ------------------------------

  // ------------------------------
  //          SRC = 0
  // ------------------------------

  // ------------------------------
  //            BYPASS
  // ------------------------------
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
