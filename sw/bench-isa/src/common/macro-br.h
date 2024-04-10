/*
 * File: macro-br.h
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-03 11:55:25 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


## ******************************
##         BRANCH INSTR
## ******************************
#define TEST_BR_TAKEN_S12(testnum, instr, nnop1, nnop2, rs1, v1, rs2, v2, rd)\
t##testnum##_start: \
  li rd, 0; \
  li rs1, DATA_XLEN(v1); \
  INSERT_NOPS_##nnop1; \
  li rs2, DATA_XLEN(v2); \
  INSERT_NOPS_##nnop2; \
  instr rs1, rs2, 1f; \
  li rd, 1; \
1: \
  TMASK_UP(testnum, rd, 0);

#define TEST_BR_TAKEN_S21(testnum, instr, nnop1, nnop2, rs1, v1, rs2, v2, rd)\
t##testnum##_start: \
  li rd, 0; \
  li rs2, DATA_XLEN(v2); \
  INSERT_NOPS_##nnop2; \
  li rs1, DATA_XLEN(v1); \
  INSERT_NOPS_##nnop1; \
  instr rs1, rs2, 1f; \
  li rd, 1; \
1: \
  TMASK_UP(testnum, rd, 0);

#define TEST_BR_NOTTAKEN_S12(testnum, instr, nnop1, nnop2, rs1, v1, rs2, v2, rd)\
t##testnum##_start: \
  li rd, 1; \
  li rs1, DATA_XLEN(v1); \
  INSERT_NOPS_##nnop1; \
  li rs2, DATA_XLEN(v2); \
  INSERT_NOPS_##nnop2; \
  instr rs1, rs2, 1f; \
  li rd, 0; \
1: \
  TMASK_UP(testnum, rd, 0);

#define TEST_BR_NOTTAKEN_S21(testnum, instr, nnop1, nnop2, rs1, v1, rs2, v2, rd)\
t##testnum##_start: \
  li rd, 1; \
  li rs2, DATA_XLEN(v2); \
  INSERT_NOPS_##nnop2; \
  li rs1, DATA_XLEN(v1); \
  INSERT_NOPS_##nnop1; \
  instr rs1, rs2, 1f; \
  li rd, 0; \
1: \
  TMASK_UP(testnum, rd, 0);

#define TEST_BR_NEXT_IMM(testnum, instr_br, instr_i, nnop, rs1, v1, rs2, v2, imm, rd)\
t##testnum##_start: \
  li rd, 0; \
  li rs1, DATA_XLEN(v1); \
  li rs2, DATA_XLEN(v2); \
  instr_br rs1, rs2, 1f; \
  instr_i rd, imm; \
1: \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, 0);

#define TEST_BR_NEXT_R(testnum, instr_br, instr_r, nnop, rs1, v1, rs2, v2, rd)\
t##testnum##_start: \
  li rd, 0; \
  li rs1, DATA_XLEN(v1); \
  li rs2, DATA_XLEN(v2); \
  instr_br rs1, rs2, 1f; \
  instr_r rd, rs1; \
1: \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, 0);

#define TEST_BR_NEXT_R_IMM(testnum, instr_br, instr_ri, nnop, rs1, v1, rs2, v2, imm, rd)\
t##testnum##_start: \
  li rd, 0; \
  li rs1, DATA_XLEN(v1); \
  li rs2, DATA_XLEN(v2); \
  instr_br rs1, rs2, 1f; \
  instr_ri rd, rs1, IMM12_SIGN_EXT(imm); \
1: \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, 0);

#define TEST_BR_NEXT_RR(testnum, instr_br, instr_rr, nnop, rs1, v1, rs2, v2, rd)\
t##testnum##_start: \
  li rd, 0; \
  li rs1, DATA_XLEN(v1); \
  li rs2, DATA_XLEN(v2); \
  instr_br rs1, rs2, 1f; \
  instr_rr rd, rs1, rs2; \
1: \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, 0);

#define TEST_BR_NEXT_LD(testnum, instr_br, instr_st, instr_ld, tbase, nnop, rs1, v1, rs2, v2, rd)\
t##testnum##_start: \
  li rd, 1; \
  la GPR_W0, tbase; \
  instr_st rd, 0(GPR_W0); \
  li rd, 0; \
  li rs1, DATA_XLEN(v1); \
  li rs2, DATA_XLEN(v2); \
  instr_br rs1, rs2, 1f; \
  instr_ld rd, 0(GPR_W0); \
1: \
  INSERT_NOPS_##nnop; \
  TMASK_UP(testnum, rd, 0);

#define TEST_BR_NEXT_ST(testnum, instr_br, instr_st, instr_ld, tbase, nnop, rs1, v1, rs2, v2, rd)\
t##testnum##_start: \
  li rd, 0; \
  la GPR_W0, tbase; \
  instr_st rd, 0(GPR_W0); \
  li rd, 1; \
  li rs1, DATA_XLEN(v1); \
  li rs2, DATA_XLEN(v2); \
  instr_br rs1, rs2, 1f; \
  instr_st rd, 0(GPR_W0); \
1: \
  INSERT_NOPS_##nnop; \
  instr_ld rd, 0(GPR_W0); \
  TMASK_UP(testnum, rd, 0);

#define TEST_C_BR_TAKEN(testnum, instr, nnop, rs1, v1, rd)\
t##testnum##_start: \
  li rd, 0; \
  li rs1, DATA_XLEN(v1); \
  INSERT_NOPS_##nnop; \
  instr rs1, 1f; \
  li rd, 1; \
1: \
  TMASK_UP(testnum, rd, 0);

#define TEST_C_BR_NOTTAKEN(testnum, instr, nnop, rs1, v1, rd)\
t##testnum##_start: \
  li rd, 1; \
  li rs1, DATA_XLEN(v1); \
  INSERT_NOPS_##nnop; \
  instr rs1, 1f; \
  li rd, 0; \
1: \
  TMASK_UP(testnum, rd, 0);
