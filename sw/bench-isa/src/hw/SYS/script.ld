/*
 * File: script.ld
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2024-04-10 01:07:49 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2024 ENSEIRB-MATMECA
 * -----
 * Description: 
 */


MEMORY
{
  ROM       (rx)  : ORIGIN = 0x04000000, LENGTH = 0x00040000
  RAM       (rwx) : ORIGIN = 0x08000000, LENGTH = 0x00040000
}

STACK_SIZE  = 0x00000800;
BOOT_PC     = 0x04000000;

SECTIONS
{
  .text BOOT_PC : {
    KEEP(*start.o(.text*));  
    *(.text)
  } > ROM

  .rodata : { 
    *(.rodata) 
  } > ROM
  
  .data : { 
    *(.data) 
  } > RAM
  
  .stack (NOLOAD):
  {
    . = ALIGN(8);
    . = . + STACK_SIZE;
    . = ALIGN(8);
    _stack = . ;
  } > RAM
}
