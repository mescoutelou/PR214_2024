/*
 * File: macro-r.h
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-09-29 02:27:23 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


## ******************************
##            R INSTR
## ******************************
#define TEST_R(testnum, instr, nnop, rs1, v1, rd, vr) \
t##testnum##_start: \
  li rs1, DATA_XLEN(v1); \
  INSERT_NOPS_##nnop; \
  instr rd, rs1; \
  TMASK_UP(testnum, rd, vr);

#define TEST_R_BYP(testnum, instr, nnop, rs1, v1, rd, vr) \
t##testnum##_start: \
  li rs1, DATA_XLEN(v1); \
  instr rd, rs1; \
  INSERT_NOPS_##nnop; \
  mv GPR_W0, rd; \
  TMASK_UP(testnum, GPR_W0, vr);

#define TEST_R_IMM(testnum, instr, nnop, rs1, v1, imm, rd, vr) \
t##testnum##_start: \
  li rs1, DATA_XLEN(v1); \
  INSERT_NOPS_##nnop; \
  instr rd, rs1, IMM12_SIGN_EXT(imm); \
  TMASK_UP(testnum, rd, vr);

#define TEST_R_IMM_BYP(testnum, instr, nnop, rs1, v1, imm, rd, vr) \
t##testnum##_start: \
  li rs1, DATA_XLEN(v1); \
  instr rd, rs1, IMM12_SIGN_EXT(imm); \
  INSERT_NOPS_##nnop; \
  mv GPR_W0, rd; \
  TMASK_UP(testnum, GPR_W0, vr);
  
#define TEST_C_R_IMM(testnum, instr, nnop, rds1, v1, imm, vr) \
t##testnum##_start: \
  li rds1, DATA_XLEN(v1); \
  INSERT_NOPS_##nnop; \
  instr rds1, IMM6_SIGN_EXT(imm); \
  TMASK_UP(testnum, rds1, vr);

#define TEST_C_R_IMM_BYP(testnum, instr, nnop, rds1, v1, imm, vr) \
t##testnum##_start: \
  li rds1, DATA_XLEN(v1); \
  instr rds1, IMM6_SIGN_EXT(imm); \
  INSERT_NOPS_##nnop; \
  mv GPR_W0, rds1; \
  TMASK_UP(testnum, GPR_W0, vr);
  