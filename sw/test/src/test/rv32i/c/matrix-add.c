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
  { 1,            4,            2,            -8,           15423       },
  { 3,            6,            8,            213645,       125643      },
  { 523425775,    3150357083,   1670624741,   3521516722,   1387072545  },
  { 1814037451,   3541999149,   2298222197,   -1562179014,  1991680015  },
  { 2486751996,   -4122211283,  2585891102,   -4288562650,  -3976001461 },
  { 457175346,    4238042633,   1695447466,   3513765704,   3118565467  }
};

const uint64_t src2[6][5] = {
  { 10,           1,            28,           -8,           33          },
  { 3,            -1,           11,           552,          1425        },
  { 2552379257,   1254608726,   454001937,    4234689489,   319841527   },
  { 3252373974,   4135202623,   1158734996,   2158096301,   1745875212  },
  { 2376881025,   2456302027,   1415573521,   2701022002,   2076049415  },
  { 2008413220,   2553551728,   3968893891,   1408166923,   1965159004  }
};

uint64_t res[6][5];

uint32_t main () {
  C_TMASK_INIT(5)

  for (uint32_t i = 0; i < 5; i = i + 1) {
    res[0][i] = src1[0][i] + src2[0][i];
  }

  C_TMASK_UP(0,   res[0][0],  11)
  C_TMASK_UP(1,   res[0][1],  5)
  
  for (uint32_t j = 1; j < 6; j = j + 1) {
    for (uint32_t i = 0; i < 5; i = i + 1) {
      res[j][i] = src1[j][i] + src2[j][i];
    }
  }

  C_TMASK_UP(2,   res[0][0],  11)
  C_TMASK_UP(3,   res[0][1],  5)
  C_TMASK_UP(4,   res[1][0],  6)

  return tmask;
} 