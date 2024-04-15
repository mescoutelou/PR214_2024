/*
 * File: macro-f.h
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2024-04-15 01:30:10 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2024 HerdWare
 * -----
 * Description: 
 */


## ******************************
##            VALUES
## ******************************
//                      S   E               M
//                      ||------||---------------------|
#define V32_N1_0000   0b10111111100000000000000000000000
#define V32_N0_5000   0b10111111000000000000000000000000
#define V32_N0_0000   0b10000000000000000000000000000000
#define V32_P0_0000   0b00000000000000000000000000000000
#define V32_P0_5000   0b00111111000000000000000000000000
#define V32_P1_0000   0b00111111100000000000000000000000
#define V32_P1_1250   0b00111111100100000000000000000000
#define V32_P1_2500   0b00111111101000000000000000000000
#define V32_P1_3750   0b00111111101100000000000000000000
#define V32_P1_5000   0b00111111110000000000000000000000
#define V32_P1_6250   0b00111111110100000000000000000000
#define V32_P1_7500   0b00111111111000000000000000000000
#define V32_P1_8750   0b00111111111100000000000000000000
#define V32_P2_0000   0b01000000000000000000000000000000
#define V32_P2_2500   0b01000000000100000000000000000000
#define V32_P2_5000   0b01000000001000000000000000000000
#define V32_P3_0000   0b01000000010000000000000000000000
#define V32_P3_5000   0b01000000011000000000000000000000
#define V32_P4_0000   0b01000000100000000000000000000000

## ******************************
##             INSTR
## ******************************
#define TEST_F_S12(testnum, instr, nnop1, nnop2, fs1, v1, fs2, v2, fd, vr) \
t##testnum##_start: \
  li GPR_W0, DATA_XLEN(v1); \
  fmv.w.x fs1, GPR_W0; \
  INSERT_NOPS_##nnop1; \
  li GPR_W0, DATA_XLEN(v2); \
  fmv.w.x fs2, GPR_W0; \
  INSERT_NOPS_##nnop2; \
  instr fd, fs1, fs2; \
  fmv.x.w GPR_W0, fd; \
  TMASK_UP(testnum, GPR_W0, vr);

#define TEST_F_S21(testnum, instr, nnop1, nnop2, rs1, v1, rs2, v2, rd, vr) \
t##testnum##_start: \
  li rs2, DATA_XLEN(v2); \
  INSERT_NOPS_##nnop2; \
  li rs1, DATA_XLEN(v1); \
  INSERT_NOPS_##nnop1; \
  instr rd, rs1, rs2; \
  TMASK_UP(testnum, rd, vr);
  