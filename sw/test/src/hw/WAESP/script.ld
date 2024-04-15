/*
 * File: script.ld
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-08-22 03:18:46 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


MEMORY
{
  BOOT     (rx)  : ORIGIN = 0x04000000, LENGTH = 0x00040000
  iRAM     (rwx) : ORIGIN = 0x0c000000, LENGTH = 0x00040000
}

STACK_SIZE  = 0x00000800;
BOOT_PC     = 0x04000000;

SECTIONS
{
  .text BOOT_PC : {
    KEEP(*start.o(.text*));  
    *(.text)
  } > BOOT

  .rodata : { 
    *(.rodata) 
  } > BOOT
  
  .data : { 
    *(.data) 
  } > iRAM
  
  .stack (NOLOAD):
  {
    . = ALIGN(8);
    . = . + STACK_SIZE;
    . = ALIGN(8);
    _stack = . ;
  } > iRAM
}
