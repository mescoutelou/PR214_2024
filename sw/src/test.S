/*
 * File: test.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2024-04-08 02:41:00 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2024 ENSEIRB-MATMECA
 * -----
 * Description: 
 */


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

## ******************************
##             END
## ******************************
.globl _end
_end:
  j _end

## ******************************
##             DATA
## ******************************
.section .data
data0: .word 0x00000000
