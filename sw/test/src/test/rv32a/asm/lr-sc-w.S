/*
 * File: lr-sc-w.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-06-13 05:39:54 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "../../../common/macro.h"
#include "macro-a.h"


// ******************************
//            INIT
// ******************************
TEST_INIT(16)

  la x10, data0
  la x11, 0
  la x12, 32
init_loop:
  beq x11, x12, init_end
  sw x0, 0(x10)
  addi x10, x10, 4
  addi x11, x11, 1
  j init_loop
init_end:
  nop

// ******************************
//             BODY
// ******************************
TEST_BODY

  // ------------------------------
  //            ACCESS
  // ------------------------------
  //            testnum,  size, instr_mem,  nnop1,  nnop2,  rs1_lr, tbase_lr, rs1_mem,  tbase_mem,  rs1_sc, tbase_sc, rs2,  v2,         rd_lr,  vr_lr,      rd_sc,  vr_sc)
  TEST_LR_SC_OK(0,        w,    lw,         0,      0,      x5,     data0,    x5,       data17,     x5,     data0,    x6,   0x00000000, x7,     0x00000000, x7,     0x00000000)
  TEST_LR_SC_OK(1,        w,    lw,         0,      0,      x5,     data16,   x5,       data1,      x5,     data16,   x6,   0x00000000, x7,     0x00000000, x7,     0x00000000)
  TEST_LR_SC_OK(2,        w,    sw,         0,      0,      x5,     data0,    x5,       data17,     x5,     data0,    x6,   0x00000000, x7,     0x00000000, x7,     0x00000000)
  TEST_LR_SC_OK(3,        w,    sw,         0,      0,      x5,     data16,   x5,       data1,      x5,     data16,   x6,   0x00000000, x7,     0x00000000, x7,     0x00000000)

  TEST_LR_SC_OK(4,        w,    lw,         0,      0,      x5,     data0,    x5,       data17,     x5,     data0,    x6,   0x00000001, x7,     0x00000000, x7,     0x00000001)
  TEST_LR_SC_KO(5,        w,    sw,         0,      0,      x5,     data0,    x5,       data0,      x5,     data0,    x6,   0x00000010, x7,     0x00000001, x7,     0x00000000)
    
  TEST_LR_SC_OK(6,        w,    lb,         0,      0,      x5,     data0,    x5,       data17,     x5,     data0,    x6,   0x0000ffff, x7,     0x00000000, x7,     0x0000ffff)
  TEST_LR_SC_KO(7,        w,    sb,         0,      0,      x5,     data0,    x5,       data0,      x5,     data0,    x6,   0x00ff0000, x7,     0x0000ffff, x7,     0x0000ff00)
    
  TEST_LR_SC_OK(8,        w,    lh,         0,      0,      x5,     data16,   x5,       data16,     x5,     data16,   x6,   0xffffffff, x7,     0x00000000, x7,     0xffffffff)
  TEST_LR_SC_KO(9,        w,    sh,         0,      0,      x5,     data16,   x5,       data16,     x5,     data16,   x6,   0x00ff0000, x7,     0xffffffff, x7,     0xffff0000)
  TEST_LR_SC_OK(10,       w,    sw,         0,      0,      x5,     data16,   x5,       data1,      x5,     data16,   x6,   0x00000001, x7,     0xffff0000, x7,     0x00000001)

  TEST_LR_SC_KO(11,       w,    lw,         0,      0,      x5,     data0,    x5,       data17,     x5,     data17,   x6,   0x00000010, x7,     0x0000ff00, x7,     0x00000000)
  TEST_LR_SC_KO(12,       w,    lw,         0,      0,      x5,     data16,   x5,       data1,      x5,     data1,    x6,   0x00000010, x7,     0x00000001, x7,     0x00000000)

  // ------------------------------
  //          SRC = OTHERS
  // ------------------------------
  TEST_LR_SC_OK(13,       w,    sw,         0,      0,      x10,    data0,    x11,      data17,     x12,    data0,    x13,  0x00000001, x14,    0x0000ff00, x15,    0x00000001)
  TEST_LR_SC_OK(14,       w,    sw,         0,      0,      x22,    data0,    x12,      data17,     x23,    data0,    x24,  0x00000002, x10,    0x00000001, x10,    0x00000002)
  TEST_LR_SC_KO(15,       w,    sw,         0,      0,      x13,    data0,    x22,      data0,      x24,    data0,    x11,  0x00000003, x10,    0x00000002, x14,    0x00000000)


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
