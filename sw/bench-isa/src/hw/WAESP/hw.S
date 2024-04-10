/*
 * File: hw.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2024-04-01 04:06:48 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2024 HerdWare
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
  rdcycle x11
  rdinstret x12

  // Test information
  li x20, ADDR_PLTF_IO_D32_OUT_DATA
  sw x10, 0(x20)  // tmask
  sw x11, 0(x20)  // cycle
  sw x12, 0(x20)  // instret

  // Set trigger end
  li x20, ADDR_PLTF_IO_GPIOC_BASE + ((GPIOC_PIN_END / 16) << 2)
  li x9, 1 << ((GPIOC_PIN_END % 16) << 1)
  sw x9, 0(x20)

  li x20, ADDR_PLTF_IO_GPIOC_BASE + 0x24
  li x9, (1 << GPIOC_PIN_END)
  sw x9, 0(x20)

  nop
  nop
  nop
  ret
  