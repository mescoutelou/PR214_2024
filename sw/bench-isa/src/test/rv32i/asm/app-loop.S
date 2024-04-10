/*
 * File: app-loop.S
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:34:03 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "../../../common/macro.h"


// ******************************
//            INIT
// ******************************
TEST_INIT(3)

// ******************************
//             BODY
// ******************************
TEST_BODY

// ------------------------------
//            PART 0
// ------------------------------
t0_start:
  li x10, 0
  li x11, 30
t0_loop:
  beq x10, x11, t0_loop_end
  addi x10, x10, 1
  j t0_loop
t0_loop_end:
  TMASK_UP(0, x10, 30)

// ------------------------------
//            PART 1
// ------------------------------
t1_start:
  li x10, 0
  li x20, 10
t1_loop:
  beq x10, x20, t1_loop_end
  jal func_inc_1
  j t1_loop
t1_loop_end:
  TMASK_UP(1, x10, 10)

// ------------------------------
//            PART 2
// ------------------------------
t2_start:
  li x10, 0
  li x20, 40
t2_loop:
  beq x10, x20, t2_loop_end
  jal func_inc_2
  j t2_loop
t2_loop_end:
  TMASK_UP(2, x10, 40)
  
// ******************************
//             END
// ******************************
TEST_RESTORE
TEST_END
  
// ******************************
//             FUNC
// ******************************
func_inc_1:
  addi x10, x10, 1
  ret

func_inc_2:
  mv x25, x1
  jal func_inc_1
  jal func_inc_1
  mv x1, x25
  ret

// ******************************
//             DATA
// ******************************
TEST_RODATA
TEST_DATA