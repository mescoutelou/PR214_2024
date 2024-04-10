/*
 * File: macro-a.h
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-03 09:01:55 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


#include "../../../common/macro.h"


## ******************************
##          LR-SC INSTR
## ******************************
#define TEST_LR_SC_OK(testnum, size, instr_mem, nnop1, nnop2, rs1_lr, tbase_lr, rs1_mem, tbase_mem, rs1_sc, tbase_sc, rs2, v2, rd_lr, vr_lr, rd_sc, vr_sc) \
t##testnum##_start: \
  la rs1_lr, tbase_lr; \
  lr.size rd_lr, (rs1_lr); \
  INSERT_NOPS_##nnop1; \
  li GPR_TTMP0, DATA_XLEN(vr_lr); \
  bne rd_lr, GPR_TTMP0, t##testnum##_end; \
  la rs1_mem, tbase_mem; \
  instr_mem x0, 0(rs1_mem); \
  la rs1_sc, tbase_sc; \
  li rs2, DATA_XLEN(v2); \
  INSERT_NOPS_##nnop2; \
  sc.size rd_sc, rs2, (rs1_sc); \
  bne rd_sc, x0, t##testnum##_end; \
  l##size GPR_W0, 0(rs1_sc); \
  li GPR_TTMP0, DATA_XLEN(vr_sc); \
  bne GPR_W0, GPR_TTMP0, t##testnum##_end; \
  li GPR_TTMP1, (1 << testnum); \
  xor GPR_TMASK, GPR_TMASK, GPR_TTMP1; \
t##testnum##_end: \
  nop  

#define TEST_LR_SC_KO(testnum, size, instr_mem, nnop1, nnop2, rs1_lr, tbase_lr, rs1_mem, tbase_mem, rs1_sc, tbase_sc, rs2, v2, rd_lr, vr_lr, rd_sc, vr_sc) \
t##testnum##_start: \
  la rs1_lr, tbase_lr; \
  lr.size rd_lr, (rs1_lr); \
  INSERT_NOPS_##nnop1; \
  li GPR_TTMP0, DATA_XLEN(vr_lr); \
  bne rd_lr, GPR_TTMP0, t##testnum##_end; \
  la rs1_mem, tbase_mem; \
  instr_mem x0, 0(rs1_mem); \
  la rs1_sc, tbase_sc; \
  li rs2, DATA_XLEN(v2); \
  INSERT_NOPS_##nnop2; \
  sc.size rd_sc, rs2, (rs1_sc); \
  beq rd_sc, x0, t##testnum##_end; \
  l##size GPR_W0, 0(rs1_sc); \
  li GPR_TTMP0, DATA_XLEN(vr_sc); \
  bne GPR_W0, GPR_TTMP0, t##testnum##_end; \
  li GPR_TTMP1, (1 << testnum); \
  xor GPR_TMASK, GPR_TMASK, GPR_TTMP1; \
t##testnum##_end: \
  nop  

## ******************************
##           AMO INSTR
## ******************************
#define TEST_AMO(testnum, instr_amo, instr_ld, nnop, rs1, tbase, rs2, v2, rd, vr1, vr2) \
t##testnum##_start: \
  la rs1, tbase; \
  li rs2, DATA_XLEN(v2); \
  INSERT_NOPS_##nnop; \
  instr_amo rd, rs2, (rs1); \
  li GPR_TTMP0, DATA_XLEN(vr1); \
  bne rd, GPR_TTMP0, t##testnum##_end; \
  instr_ld GPR_W0, 0(rs1); \
  li GPR_TTMP0, DATA_XLEN(vr2); \
  bne GPR_W0, GPR_TTMP0, t##testnum##_end; \
  li GPR_TTMP1, (1 << testnum); \
  xor GPR_TMASK, GPR_TMASK, GPR_TTMP1; \
t##testnum##_end: \
  nop  

#define TEST_AMO_BYP(testnum, instr_amo, instr_ld, nnop, rs1, tbase, rs2, v2, rd, vr1, vr2) \
t##testnum##_start: \
  la rs1, tbase; \
  li rs2, DATA_XLEN(v2); \
  instr_amo rd, rs2, (rs1); \
  INSERT_NOPS_##nnop; \
  mv GPR_W0, rd; \
  li GPR_TTMP0, DATA_XLEN(vr1); \
  bne GPR_W0, GPR_TTMP0, t##testnum##_end; \
  instr_ld GPR_W0, 0(rs1); \
  li GPR_TTMP0, DATA_XLEN(vr2); \
  bne GPR_W0, GPR_TTMP0, t##testnum##_end; \
  li GPR_TTMP1, (1 << testnum); \
  xor GPR_TMASK, GPR_TMASK, GPR_TTMP1; \
t##testnum##_end: \
  nop 
