/*
 * File: hw.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2024-04-10 01:09:23 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2024 ENSEIRB-MATMECA
 * -----
 * Description: 
 */
 

#include "hw.h"


.section .text

.globl _hw_init
_hw_init:
  ret

.globl _end_trigger
_end_trigger:
  rdinstret x28
  rdcycle x29
  mv x30, x10
  li x31, 0x80000000

  nop
  nop
  nop
  ret
  