/*
 * File: lui.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:35:01 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "../../../common/macro.h"
#include "../../../common/macro-imm.h"


// ******************************
//            INIT
// ******************************
TEST_INIT(10)

// ******************************
//             BODY
// ******************************
TEST_BODY
  //        testnum,  instr,  nnop, imm,      rd,   vr
  TEST_IMM( 0,        lui,    0,    0x00000,  x7,   0x0000000000000000)
  TEST_IMM( 1,        lui,    0,    0xfffff,  x7,   0xfffffffffffff000)
  TEST_IMM( 2,        lui,    0,    0x7ffff,  x7,   0x000000007ffff000)
  TEST_IMM( 3,        lui,    0,    0x80000,  x7,   0xffffffff80000000)

  TEST_IMM( 4,        lui,    1,    0x01234,  x10,  0x0000000001234000)
  TEST_IMM( 5,        lui,    2,    0x88888,  x11,  0xffffffff88888000)
  TEST_IMM( 6,        lui,    4,    0x10000,  x12,  0x0000000010000000)
  TEST_IMM( 7,        lui,    8,    0x00000,  x12,  0x0000000000000000)

  TEST_IMM( 8,        lui,    0,    0xfffff,  x0,   0x0000000000000000)
  TEST_IMM( 9,        lui,    0,    0x00001,  x0,   0x0000000000000000)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
