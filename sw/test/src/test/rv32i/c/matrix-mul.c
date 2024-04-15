/*
 * File: matrix-add.c
 * Created Date: 2023-11-06 08:29:07 am
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-11-06 10:02:57 am
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2023 HerdWare
 * -----
 * Description: 
 */

#include <stdlib.h>
#include <stdint.h>
#include "../../../common/macro-c.h"


const uint64_t src1[6][5] = {
  { 1,            0,            0,            0,            1           },
  { 3,            6,            8,            -4,           125643      },
  { 523425775,    3150357083,   1670624741,   3521516722,   1387072545  },
  { 1814037451,   3541999149,   2298222197,   -1562179014,  1991680015  },
  { 2486751996,   -4122211283,  2585891102,   -4288562650,  -3976001461 },
  { 457175346,    4238042633,   1695447466,   3513765704,   3118565467  }
};

const uint64_t src2[5][4] = {
  { 10,           1,            28,           -8            },
  { 3,            -1,           11,           552           },
  { 2,            -8,           454001937,    4234689489    },
  { 55,           5,            1158734996,   2158096301    },
  { -48,          12,           1415573521,   2701022002    }
};

uint64_t res[6][4];

uint32_t main () {
  C_TMASK_INIT(5)

  for (uint32_t i0 = 0; i0 < 4; i0 = i0 + 1) {
    res[0][i0] = 0;
    for (uint32_t j1 = 0; j1 < 5; j1 = j1 + 1) {
      for (uint32_t i1 = 0; i1 < 5; i1 = i1 + 1) {
        res[0][i0] = res[0][i0] + src1[0][i1] * src2[j1][i0];
      }
    }
  }

  C_TMASK_UP(0,   res[0][0],  11)
  C_TMASK_UP(1,   res[0][1],  5)
  
  for (uint32_t j0 = 0; j0 < 5; j0 = j0 + 1) {
    for (uint32_t i0 = 0; i0 < 4; i0 = i0 + 1) {
      res[j0][i0] = 0;
      for (uint32_t j1 = 0; j1 < 5; j1 = j1 + 1) {
        for (uint32_t i1 = 0; i1 < 5; i1 = i1 + 1) {
          res[j0][i0] = res[j0][i0] + src1[j0][i1] * src2[j1][i0];
        }
      }
    }
  }

  C_TMASK_UP(2,   res[0][0],  11)
  C_TMASK_UP(3,   res[0][1],  5)
  C_TMASK_UP(4,   res[1][0],  6)

  return tmask;
} 