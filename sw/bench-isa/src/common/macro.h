/*
 * File: macro.h
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-02 08:33:34 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */


## ******************************
##           CONSTANTS
## ******************************
#define GPR_W0    x8
#define GPR_W1    x9
#define GPR_TTMP0 x28
#define GPR_TTMP1 x29
#define GPR_TMASK x30

## ******************************
##           FUNCTIONS
## ******************************
#define DATA_XLEN(x) ((x) & (((1 << (XLEN - 1)) << 1) - 1))

#define IMM_SIGN_EXT(x, nbit) ((x) | (-(((x) >> (nbit - 1)) & 1) << (nbit - 1)))
#define IMM6_SIGN_EXT(x) IMM_SIGN_EXT(x, 6)
#define IMM12_SIGN_EXT(x) IMM_SIGN_EXT(x, 12)

## ******************************
##           FILLING
## ******************************
#define INSERT_NOPS_0
#define INSERT_NOPS_1   nop; INSERT_NOPS_0
#define INSERT_NOPS_2   nop; INSERT_NOPS_1
#define INSERT_NOPS_3   nop; INSERT_NOPS_2
#define INSERT_NOPS_4   nop; INSERT_NOPS_3
#define INSERT_NOPS_5   nop; INSERT_NOPS_4
#define INSERT_NOPS_6   nop; INSERT_NOPS_5
#define INSERT_NOPS_7   nop; INSERT_NOPS_6
#define INSERT_NOPS_8   nop; INSERT_NOPS_7
#define INSERT_NOPS_9   nop; INSERT_NOPS_8
#define INSERT_NOPS_10  nop; INSERT_NOPS_9
#define INSERT_NOPS_11  nop; INSERT_NOPS_10
#define INSERT_NOPS_12  nop; INSERT_NOPS_11
#define INSERT_NOPS_13  nop; INSERT_NOPS_12
#define INSERT_NOPS_14  nop; INSERT_NOPS_13
#define INSERT_NOPS_15  nop; INSERT_NOPS_14
#define INSERT_NOPS_16  nop; INSERT_NOPS_15
#define INSERT_NOPS_17  nop; INSERT_NOPS_16
#define INSERT_NOPS_18  nop; INSERT_NOPS_17
#define INSERT_NOPS_19  nop; INSERT_NOPS_18
#define INSERT_NOPS_20  nop; INSERT_NOPS_19
#define INSERT_NOPS_21  nop; INSERT_NOPS_20
#define INSERT_NOPS_22  nop; INSERT_NOPS_21
#define INSERT_NOPS_23  nop; INSERT_NOPS_22
#define INSERT_NOPS_24  nop; INSERT_NOPS_23
#define INSERT_NOPS_25  nop; INSERT_NOPS_24
#define INSERT_NOPS_26  nop; INSERT_NOPS_25
#define INSERT_NOPS_27  nop; INSERT_NOPS_26
#define INSERT_NOPS_28  nop; INSERT_NOPS_27
#define INSERT_NOPS_29  nop; INSERT_NOPS_28
#define INSERT_NOPS_30  nop; INSERT_NOPS_29
#define INSERT_NOPS_31  nop; INSERT_NOPS_30
#define INSERT_NOPS_32  nop; INSERT_NOPS_31
#define INSERT_NOPS_33  nop; INSERT_NOPS_32
#define INSERT_NOPS_34  nop; INSERT_NOPS_33
#define INSERT_NOPS_35  nop; INSERT_NOPS_34
#define INSERT_NOPS_36  nop; INSERT_NOPS_35
#define INSERT_NOPS_37  nop; INSERT_NOPS_36
#define INSERT_NOPS_38  nop; INSERT_NOPS_37
#define INSERT_NOPS_39  nop; INSERT_NOPS_38
#define INSERT_NOPS_40  nop; INSERT_NOPS_39
#define INSERT_NOPS_41  nop; INSERT_NOPS_40
#define INSERT_NOPS_42  nop; INSERT_NOPS_41
#define INSERT_NOPS_43  nop; INSERT_NOPS_42
#define INSERT_NOPS_44  nop; INSERT_NOPS_43
#define INSERT_NOPS_45  nop; INSERT_NOPS_44
#define INSERT_NOPS_46  nop; INSERT_NOPS_45
#define INSERT_NOPS_47  nop; INSERT_NOPS_46
#define INSERT_NOPS_48  nop; INSERT_NOPS_47
#define INSERT_NOPS_49  nop; INSERT_NOPS_48
#define INSERT_NOPS_50  nop; INSERT_NOPS_49

## ******************************
##           TEST MASK
## ******************************
#define TMASK_INIT(ntest) li x30, ((1 << (ntest)) - 1)
#define TMASK_SET(val) li x30, val;
#define TMASK_UP(testnum, rd, vr) \
  li GPR_TTMP0, DATA_XLEN(vr); \
  bne rd, GPR_TTMP0, t##testnum##_end; \
  li GPR_TTMP1, (1 << testnum); \
  xor GPR_TMASK, GPR_TMASK, GPR_TTMP1; \
t##testnum##_end: \
  nop

#define TMASK_TRUE(testnum)\
  TMASK_UP(testnum, x0, 0); \

#define TMASK_FALSE(testnum)\
  TMASK_UP(testnum, x0, 1); \

## ******************************
##           TEST PART
## ******************************
#define TEST_INIT(ntest)\
.section .text; \
.globl main; \
main: \
test_init: \
  TMASK_INIT(ntest)

#define TEST_BODY \
test_body:  

#define TEST_RESTORE \
test_restore:

#define TEST_END \
test_end: \
  mv x10, GPR_TMASK; \
  j _end

#define TEST_DATA \
.section .data; \
.align 3;

#define TEST_RODATA \
.section .rodata; \
.align 3;


