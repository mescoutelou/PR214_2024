/*
 * File: macro-imm.h
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:27:08 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


## ******************************
##           IMM INSTR
## ******************************
#define TEST_IMM(testnum, instr, nnop, imm, rd, vr) \
t##testnum##_start: \
  instr rd, imm; \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, vr);
