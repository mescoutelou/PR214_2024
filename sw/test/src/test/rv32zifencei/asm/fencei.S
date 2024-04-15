/*
 * File: fencei.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-12 06:35:02 pm
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
#define INSTR_NOP           0x00000013
#define INSTR_RET           0x00008067
#define INSTR_ADDI_X5_X5_1  0x00128293

#define TEST_FENCEI(testnum, nnop1, nnop2, rs1, vr) \
t##testnum##_start: \
  INSERT_NOPS_##nnop1; \
  fence.i; \
  INSERT_NOPS_##nnop2; \
  jalr x1, rs1; \
  TMASK_UP(testnum, x5, vr); \
  li x5, 0; \
  

// ******************************
//            INIT
// ******************************
TEST_INIT(10)
  li x5, 0
  la x6, data0
  li x7, 15
test_init_data_loop:
  li x8, INSTR_NOP
  sw x8, 0(x6)
  addi x5, x5, 1
  addi x6, x6, 4
  bne x5, x7, test_init_data_loop 
  la x6, data15
  li x8, INSTR_RET
  sw x8, 0(x6)
  li x5, 0

// ******************************
//             BODY
// ******************************
TEST_BODY
  // ------------------------------
  //             LOGIC
  // ------------------------------
  //          testnum,  nnop1,  nnop2,  rs1,  vr
  la x6, data0;
  TEST_FENCEI(0,        0,      0,      x6,   0)

  la x6, data0
  li x8, INSTR_ADDI_X5_X5_1
  sw x8, 0(x6)
  TEST_FENCEI(1,        0,      0,      x6,   1)

  la x6, data0
  li x8, INSTR_ADDI_X5_X5_1
  sw x8, 4(x6)
  sw x8, 12(x6)
  sw x8, 16(x6)
  TEST_FENCEI(2,        0,      0,      x6,   4)

  la x6, data0
  li x8, INSTR_ADDI_X5_X5_1
  sw x8, 20(x6)
  TEST_FENCEI(3,        1,      0,      x6,   5)

  la x6, data0
  li x8, INSTR_ADDI_X5_X5_1
  sw x8, 24(x6)
  TEST_FENCEI(4,        2,      0,      x6,   6)

  la x6, data0
  li x8, INSTR_NOP
  sw x8, 24(x6)
  TEST_FENCEI(5,        4,      0,      x6,   5)

  la x6, data0
  li x8, INSTR_NOP
  sw x8, 4(x6)
  la x9, data0
  TEST_FENCEI(6,        1,      2,      x9,   4)

  la x6, data0
  li x8, INSTR_RET
  sw x8, 0(x6)
  la x9, data0
  TEST_FENCEI(7,        2,      2,      x9,   0)

  // ------------------------------
  //             ORDER
  // ------------------------------
t8_start:
  li x5, 1
  fence.i;
  addi x5, x5, 4
  TMASK_UP(8, x5, 5);
  li x5, 0;

t9_start:
  li x5, 10
  fence.i;
  nop 
  nop 
  nop 
  nop
  addi x5, x5, 10
  TMASK_UP(9, x5, 20);
  li x5, 0;
  
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
  data0:  .word 0x00000000 // INSTR_NOP
  data1:  .word 0x00000000 // INSTR_NOP
  data2:  .word 0x00000000 // INSTR_NOP
  data3:  .word 0x00000000 // INSTR_NOP
  data4:  .word 0x00000000 // INSTR_NOP
  data5:  .word 0x00000000 // INSTR_NOP
  data6:  .word 0x00000000 // INSTR_NOP
  data7:  .word 0x00000000 // INSTR_NOP
  data8:  .word 0x00000000 // INSTR_NOP
  data9:  .word 0x00000000 // INSTR_NOP
  data10: .word 0x00000000 // INSTR_NOP
  data11: .word 0x00000000 // INSTR_NOP
  data12: .word 0x00000000 // INSTR_NOP
  data13: .word 0x00000000 // INSTR_NOP
  data14: .word 0x00000000 // INSTR_NOP
  data15: .word 0x00000000 // INSTR_RET
