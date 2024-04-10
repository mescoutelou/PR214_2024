/*
 * File: test.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2024-04-10 02:28:49 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2024 ENSEIRB-MATMECA
 * -----
 * Description: 
 */

#include "test.h"

.section .text
## ******************************
##             BOOT
## ******************************
.globl _start
_start:
  la sp, _stack

## ******************************
##             MAIN
## ******************************
main:
  li x4, 1
  li x5, 2
  la x6, data0
  sw x5, 0(x6)
  lw x7, 0(x6)
  la x6, data1
  li x5, 0xff
  sw x5, 0(x6)
  lb x7, 0(x6)

  fmv.w.x f0, x4
//  fli.s ft4, 0.0625
  rdcycle x10
  rdinstret x11
  
  li x10, V32_1_0000
  fmv.w.x f10, x10
  fadd.s f11, f10, f10
  li x10, V32_2_0000
  fmv.w.x f12, x10
  fadd.s f13, f10, f11
  fadd.s f14, f12, f12
  li x10, V32_3_0000
  fmv.w.x f15, x10
  li x10, V32_4_0000
  fmv.w.x f15, x10

  li x10, V32_1_1250
  fmv.w.x f16, x10
  fadd.s f17, f16, f16
  li x10, V32_2_2500
  fmv.w.x f18, x10

## ******************************
##             END
## ******************************
.globl _end
_end:
  li x31, 0x80000000
_end_loop:
  j _end

## ******************************
##             DATA
## ******************************
.section .data
data0: .word 0x00000000
data1: .word 0x00000000
