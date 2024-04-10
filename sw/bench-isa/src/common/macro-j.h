/*
 * File: macro-j.h
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-02-27 08:27:12 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


## ******************************
##          JUMP INSTR
## ******************************
#define TEST_J_NEXT_IMM(testnum, instr_i, nnop, imm, rd)\
t##testnum##_start: \
  li rd, 0; \
  j 1f; \
  instr_i rd, imm; \
1: \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, 0);

#define TEST_J_NEXT_R(testnum, instr_r, nnop, rs1, v1, rd)\
t##testnum##_start: \
  li rd, 0; \
  li rs1, DATA_XLEN(v1); \
  j 1f; \
  instr_r rd, rs1; \
1: \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, 0);

#define TEST_J_NEXT_R_IMM(testnum, instr_ri, nnop, rs1, v1, imm, rd)\
t##testnum##_start: \
  li rd, 0; \
  li rs1, DATA_XLEN(v1); \
  j 1f; \
  instr_ri rd, rs1, IMM12_SIGN_EXT(imm); \
1: \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, 0);

#define TEST_J_NEXT_RR(testnum, instr_rr, nnop, rs1, v1, rs2, v2, rd)\
t##testnum##_start: \
  li rd, 0; \
  li rs1, DATA_XLEN(v1); \
  li rs2, DATA_XLEN(v2); \
  j 1f; \
  instr_rr rd, rs1, rs2; \
1: \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, 0);

#define TEST_J_NEXT_LD(testnum, instr_st, instr_ld, tbase, nnop, rd)\
t##testnum##_start: \
  la GPR_W0, tbase; \
  li rd, 1; \
  instr_st rd, 0(GPR_W0); \
  li rd, 0; \
  j 1f; \
  instr_ld rd, 0(GPR_W0); \
1: \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, 0);

#define TEST_J_NEXT_ST(testnum, instr_st, instr_ld, tbase, nnop, rd)\
t##testnum##_start: \
  la GPR_W0, tbase; \
  li rd, 0; \
  instr_st rd, 0(GPR_W0); \
  li rd, 1; \
  j 1f; \
  instr_st rd, 0(GPR_W0); \
1: \
  INSERT_NOPS_##nnop; \
  instr_ld rd, 0(GPR_W0); \
  TMASK_UP(testnum, rd, 0);

#define TEST_JR_NEXT_IMM(testnum, instr_i, nnop, imm, rd)\
t##testnum##_start: \
  la GPR_W1, 1f; \
  li rd, 0; \
  jr GPR_W1; \
  instr_i rd, imm; \
1: \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, 0);

#define TEST_JR_NEXT_R(testnum, instr_r, nnop, rs1, v1, rd)\
t##testnum##_start: \
  la GPR_W1, 1f; \
  li rd, 0; \
  li rs1, DATA_XLEN(v1); \
  jr GPR_W1; \
  instr_r rd, rs1; \
1: \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, 0);

#define TEST_JR_NEXT_R_IMM(testnum, instr_ri, nnop, rs1, v1, imm, rd)\
t##testnum##_start: \
  li rs1, DATA_XLEN(v1); \
  la GPR_W1, 1f; \
  li rd, 0; \
  jr GPR_W1; \
  instr_ri rd, rs1, IMM12_SIGN_EXT(imm); \
1: \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, 0);

#define TEST_JR_NEXT_RR(testnum, instr_rr, nnop, rs1, v1, rs2, v2, rd)\
t##testnum##_start: \
  la GPR_W1, 1f; \
  li rd, 0; \
  li rs1, DATA_XLEN(v1); \
  li rs2, DATA_XLEN(v2); \
  jr GPR_W1; \
  instr_rr rd, rs1, rs2; \
1: \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, 0);

#define TEST_JR_NEXT_LD(testnum, instr_st, instr_ld, tbase, nnop, rd)\
t##testnum##_start: \
  la GPR_W0, tbase; \
  la GPR_W1, 1f; \
  li rd, 1; \
  instr_st rd, 0(GPR_W0); \
  li rd, 0; \
  jr GPR_W1; \
  instr_ld rd, 0(GPR_W0); \
1: \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, 0);

#define TEST_JR_NEXT_ST(testnum, instr_st, instr_ld, tbase, nnop, rd)\
t##testnum##_start: \
  la GPR_W0, tbase; \
  la GPR_W1, 1f; \
  li rd, 0; \
  instr_st rd, 0(GPR_W0); \
  li rd, 1; \
  jr GPR_W1; \
  instr_st rd, 0(GPR_W0); \
1: \
  INSERT_NOPS_##nnop; \
  instr_ld rd, 0(GPR_W0); \
  TMASK_UP(testnum, rd, 0);
  