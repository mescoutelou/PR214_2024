/*
 * File: fibonacci.c
 * Created Date: 2023-10-02 08:29:07 am
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2023-10-02 10:02:57 am
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

uint32_t fibonacci(uint32_t n) {
  if (n <= 1) {
      return n;
  } else {
    return fibonacci(n - 1) + fibonacci(n - 2);
  }    
}



uint32_t main () {
  C_TMASK_INIT(7)

  C_TMASK_UP(0, fibonacci(2), 1)
  C_TMASK_UP(1, fibonacci(3), 2)
  C_TMASK_UP(2, fibonacci(7), 13)
  C_TMASK_UP(3, fibonacci(10), 55)
  C_TMASK_UP(4, fibonacci(12), 144)
  C_TMASK_UP(5, fibonacci(14), 377)
  C_TMASK_UP(6, fibonacci(15), 610)

  return tmask;
} 