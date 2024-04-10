/*
 * File: app-hcf.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:33:59 am
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
#define TEST_HCF_LOAD(testnum, va0, va1, vr) \
t##testnum##_start: \
  addi sp, sp, -8; \
  lw a1, va0; \
  lw a2, va1; \
  sw a1, 4(sp); \
  sw a2, 0(sp); \
  jal ra, hcf; \
  lw s0, 0(sp); \
  addi sp, sp, 4; \
  \
  TMASK_UP(testnum, s0, vr)

// ******************************
//            INIT
// ******************************
TEST_INIT(3)

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //             LOAD
  // ------------------------------
  TEST_HCF_LOAD(0, rodata0, rodata1, 17)    ## A = 51,    B = 17,     HCF = 17
  TEST_HCF_LOAD(1, rodata2, rodata3, 10)    ## A = 10,    B = 170,    HCF = 10
  TEST_HCF_LOAD(2, rodata4, rodata5, 1600)  ## A = 20800, B = 80000,  HCF = 1600

// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END

// ******************************
//             HCF
// ******************************
hcf:
  lw a4, 4(sp)
  lw a5, 0(sp)
  addi sp, sp, 8

## if a4 = a5 then HCF = a4 = a5
  bne a4, a5, hcf_great
  addi sp, sp, -4
  sw a4, 0(sp)
  jalr zero, ra, 0

## if a5 < a4 then we do a6 = a5 - a4
hcf_great:
  blt a5, a4, hcf_less
  sub a6, a5, a4
  addi sp, sp, -8
  sw a4, 4(sp)
  sw a6, 0(sp)
  j hcf

## else we do a6 = a4 -a5
hcf_less:
  sub a6, a4, a5
  addi sp, sp, -8
  sw a5, 4(sp)
  sw a6, 0(sp)
  j hcf

// ******************************
//             DATA
// ******************************
TEST_RODATA
rodata0:  .word 0x00000033
rodata1:  .word 0x00000011
rodata2:  .word 0x0000000a
rodata3:  .word 0x000000aa
rodata4:  .word 0x00005140
rodata5:  .word 0x00013880
TEST_DATA
data0:    .word 0x00000000
data1:    .word 0x00000000
data2:    .word 0x00000000