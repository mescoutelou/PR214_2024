/*
 * File: app-array.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:33:48 am
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
#define TEST_ARRAY_LOAD(testnum, tbase, rd, vr) \
t##testnum##_start: \
  la GPR_W0, tbase; \
  lw rd, 0(GPR_W0); \
  TMASK_UP(testnum, rd, vr)

// ******************************
//            INIT
// ******************************
TEST_INIT(19)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //           INIT TABLE
  // ------------------------------
  la x10, data0
  li x11, 0
  li x12, 32
init_loop:
  beq x11, x12, init_end
  sw x11, 0(x10)
  addi x10, x10, 4
  addi x11, x11, 1
  j init_loop
init_end:
  nop

  //              testnum,  tbase,  rd,   vr
  TEST_ARRAY_LOAD(0,        data0,  x7,   0x00000000)
  TEST_ARRAY_LOAD(1,        data10, x7,   0x0000000a)
  TEST_ARRAY_LOAD(2,        data31, x7,   0x0000001f)
  TEST_ARRAY_LOAD(3,        data3,  x7,   0x00000003)
  TEST_ARRAY_LOAD(4,        data2,  x7,   0x00000002)

  // ------------------------------
  //             WRITE
  // ------------------------------
  la x10, data0
  sw x0, 32(x10)
  sw x0, 36(x10)
  sw x0, 16(x10)

  //              testnum,  tbase,  rd,   vr
  TEST_ARRAY_LOAD(5,        data4,  x7,   0x00000000)
  TEST_ARRAY_LOAD(6,        data8,  x7,   0x00000000)
  TEST_ARRAY_LOAD(7,        data10, x7,   0x0000000a)

  // ------------------------------
  //              READ
  // ------------------------------
  la x10, data0
  li x11, 0
  li x12, 32
  li x7, 0
read_loop:
  beq x11, x12, read_end
  lw x13, 0(x10)
  add x7, x7, x13
  addi x10, x10, 4
  addi x11, x11, 1
  j read_loop
read_end:
  nop
  TMASK_UP(8, x7, 475)

  // ------------------------------
  //         SERIAL ACCESS
  // ------------------------------
  la x10, data0
  
  li x11, 1
  sw x11, 0(x10)
  sw x11, 4(x10)
  sw x11, 8(x10)
  sw x11, 12(x10)
  sw x11, 16(x10)
  sw x11, 20(x10)
  sw x11, 24(x10)
  sw x11, 28(x10)
  sw x11, 32(x10)
  sw x11, 36(x10)
  sw x11, 40(x10)
  sw x11, 44(x10)
  sw x11, 48(x10)
  sw x11, 52(x10)
  sw x11, 56(x10)
  sw x11, 60(x10)
  
  li x11, 2
  sw x11, 64(x10)
  sw x11, 68(x10)
  sw x11, 72(x10)
  sw x11, 76(x10)
  sw x11, 80(x10)
  sw x11, 84(x10)

  lw x11, 76(x10)
  lw x12, 12(x10)
  lw x13, 16(x10)
  lw x14, 0(x10)
  lw x15, 12(x10)
  lw x16, 20(x10)
  lw x17, 80(x10)
  lw x18, 24(x10)
  lw x19, 20(x10)
  lw x20, 20(x10)

  TEST_ARRAY_LOAD(9,        data19, x11,  0x00000002)
  TEST_ARRAY_LOAD(10,       data3,  x12,  0x00000001)
  TEST_ARRAY_LOAD(11,       data4,  x13,  0x00000001)
  TEST_ARRAY_LOAD(12,       data0,  x14,  0x00000001)
  TEST_ARRAY_LOAD(13,       data3,  x15,  0x00000001)
  TEST_ARRAY_LOAD(14,       data5,  x16,  0x00000001)
  TEST_ARRAY_LOAD(15,       data20, x17,  0x00000002)
  TEST_ARRAY_LOAD(16,       data6,  x18,  0x00000001)
  TEST_ARRAY_LOAD(17,       data5,  x19,  0x00000001)
  TEST_ARRAY_LOAD(18,       data5,  x20,  0x00000001)

// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END

// ******************************
//             DATA
// ******************************
TEST_RODATA

TEST_DATA
data0:    .word 0x00000000
data1:    .word 0x00000000
data2:    .word 0x00000000
data3:    .word 0x00000000
data4:    .word 0x00000000
data5:    .word 0x00000000
data6:    .word 0x00000000
data7:    .word 0x00000000
data8:    .word 0x00000000
data9:    .word 0x00000000
data10:   .word 0x00000000
data11:   .word 0x00000000
data12:   .word 0x00000000
data13:   .word 0x00000000
data14:   .word 0x00000000
data15:   .word 0x00000000
data16:   .word 0x00000000
data17:   .word 0x00000000
data18:   .word 0x00000000
data19:   .word 0x00000000
data20:   .word 0x00000000
data21:   .word 0x00000000
data22:   .word 0x00000000
data23:   .word 0x00000000
data24:   .word 0x00000000
data25:   .word 0x00000000
data26:   .word 0x00000000
data27:   .word 0x00000000
data28:   .word 0x00000000
data29:   .word 0x00000000
data30:   .word 0x00000000
data31:   .word 0x00000000