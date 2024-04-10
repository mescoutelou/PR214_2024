/*
 * File: macro-c.h
 * Created Date: 2023-10-02 08:57:57 am
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-02 09:35:48 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */

#define TEST_C_MV_RESULT \
asm volatile ( \
  "mv x30, %[r1]\n" \
  : \
  : [r1] "r" (tmask) \
  : \
);

#define C_TMASK_INIT(ntest) \
uint32_t tmask = ((1 << (ntest)) - 1);

#define C_TMASK_UP(testnum, val, ref) \
if (val == ref) { \
  tmask = tmask ^ (1 << testnum); \
} \
asm volatile ( \
  "mv x30, %[r1]\n" \
  : \
  : [r1] "r" (tmask) \
  : \
);
