/*
 * File: macro-mem.h
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:27:17 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


## ******************************
##         MEMORY INSTR
## ******************************
#define TEST_LD(testnum, instr, nnop, rs1, tbase, voffset, rd, vr) \
t##testnum##_start: \
  la rs1, tbase; \
  INSERT_NOPS_##nnop; \
  instr rd, voffset(rs1); \
  TMASK_UP(testnum, rd, vr);

#define TEST_LD_BYP(testnum, instr, nnop, rs1, tbase, voffset, rd, vr) \
t##testnum##_start: \
  la rs1, tbase; \
  instr rd, voffset(rs1); \
  INSERT_NOPS_##nnop; \
  mv GPR_W0, rd; \
  TMASK_UP(testnum, GPR_W0, vr);

#define TEST_ST_S12(testnum, instr_st, instr_ld, nnop1, nnop2, rs1, tbase, voffset, rs2, v2) \
t##testnum##_start: \
  la rs1, tbase; \
  INSERT_NOPS_##nnop1; \
  li rs2, DATA_XLEN(v2); \
  INSERT_NOPS_##nnop2; \
  instr_st rs2, voffset(rs1); \
  instr_ld GPR_W0, voffset(rs1); \
  TMASK_UP(testnum, GPR_W0, v2);

#define TEST_ST_S21(testnum, instr_st, instr_ld, nnop1, nnop2, rs1, tbase, voffset, rs2, v2) \
t##testnum##_start: \
  li rs2, DATA_XLEN(v2); \
  INSERT_NOPS_##nnop2; \
  la rs1, tbase; \
  INSERT_NOPS_##nnop1; \
  instr_st rs2, voffset(rs1); \
  instr_ld GPR_W0, voffset(rs1); \
  TMASK_UP(testnum, GPR_W0, v2);

#define TEST_ST_LD(testnum, instr_st, instr_ld, nnop, rs1, tbase, voffset, rs2, v2, rd) \
t##testnum##_start: \
  li rs2, DATA_XLEN(v2); \
  la rs1, tbase; \
  instr_st rs2, voffset(rs1); \
  INSERT_NOPS_##nnop; \
  instr_ld rd, voffset(rs1); \
  TMASK_UP(testnum, rd, v2);
