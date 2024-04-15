/*
 * File: func.c
 * Created Date: 2024-04-11 08:31:15 am
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2024-04-11 01:22:31 pm
 * Modified By: Mathieu Escouteloup
 * Email: mathieu.escouteloup@ims-bordeaux.com
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2024 ENSEIRB-MATMECA
 * -----
 * Description: 
 */


#include "func.h"


uint32_t func() {
  volatile float fval0 = 1.0; 
  fval0 = fval0 + 1.5;
  fval0 = fval0 - 3.0;
  
  volatile float fval1 = -0.5; 
  volatile float fval2 = 64.0; 
  volatile float fval3 = -64.0; 
  return 0;
}