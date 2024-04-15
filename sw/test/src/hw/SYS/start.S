/*
 * File: start.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-02 08:55:50 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


.section .data
.section .text
## ******************************
##             BOOT
## ******************************
.globl _start
_start:
  la sp, _stack
  jal _hw_init

## ******************************
##          GLOBAL INIT
## ******************************
glob_init:
  li x30, -1
  jal main

## ******************************
##             END
## ******************************
.globl _end
_end:
  jal _end_trigger
_end_loop:
  j _end_loop
