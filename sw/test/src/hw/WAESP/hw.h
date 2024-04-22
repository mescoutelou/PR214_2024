/*
 * File: hw.h
 * Created Date: 2023-02-26 09:08:32 pm
 * Author: Mathieu Escouteloup
 * -----
 * Last Modified: 2024-04-01 04:02:35 pm
 * Modified By: Mathieu Escouteloup
 * -----
 * License: See LICENSE.md
 * Copyright (c) 2024 HerdWare
 * -----
 * Description: 
 */

#define ADDR_PLTF_IO_GPIOA_BASE     0x1c010400
#define ADDR_PLTF_IO_GPIOA_MODE     0x1c010400
#define ADDR_PLTF_IO_GPIOA_MODEH    0x1c010404
#define ADDR_PLTF_IO_GPIOA_DIN      0x1c010420
#define ADDR_PLTF_IO_GPIOA_DOUT     0x1c010424
#define ADDR_PLTF_IO_GPIOA_DSET     0x1c010428
#define ADDR_PLTF_IO_GPIOA_DRST     0x1c01042c
#define ADDR_PLTF_IO_GPIOB_BASE     0x1c010480
#define ADDR_PLTF_IO_GPIOB_MODE     0x1c010480
#define ADDR_PLTF_IO_GPIOB_MODEH    0x1c010484
#define ADDR_PLTF_IO_GPIOB_DIN      0x1c0104a0
#define ADDR_PLTF_IO_GPIOB_DOUT     0x1c0104a4
#define ADDR_PLTF_IO_GPIOB_DSET     0x1c0104a8
#define ADDR_PLTF_IO_GPIOB_DRST     0x1c0104ac
#define ADDR_PLTF_IO_GPIOC_BASE     0x1c010500
#define ADDR_PLTF_IO_GPIOC_MODE     0x1c010500
#define ADDR_PLTF_IO_GPIOC_MODEH    0x1c010504
#define ADDR_PLTF_IO_GPIOC_DIN      0x1c010520
#define ADDR_PLTF_IO_GPIOC_DOUT     0x1c010524
#define ADDR_PLTF_IO_GPIOC_DSET     0x1c010528
#define ADDR_PLTF_IO_GPIOC_DRST     0x1c01052c
#define ADDR_PLTF_IO_GPIOD_BASE     0x1c010580
#define ADDR_PLTF_IO_GPIOD_MODE     0x1c010580
#define ADDR_PLTF_IO_GPIOD_MODEH    0x1c010584
#define ADDR_PLTF_IO_GPIOD_DIN      0x1c0105a0
#define ADDR_PLTF_IO_GPIOD_DOUT     0x1c0105a4
#define ADDR_PLTF_IO_GPIOD_DSET     0x1c0105a8
#define ADDR_PLTF_IO_GPIOD_DRST     0x1c0105ac
#define ADDR_PLTF_IO_D32_IN_VALID   0x1c020000
#define ADDR_PLTF_IO_D32_IN_DATA    0x1c020004
#define ADDR_PLTF_IO_D32_OUT_READY  0x1c020008
#define ADDR_PLTF_IO_D32_OUT_DATA   0x1c02000c

#define GPIOB_PIN_LED0    0
#define GPIOB_PIN_LED1    1
#define GPIOB_PIN_LED2    2
#define GPIOB_PIN_LED3    3
#define GPIOC_PIN_END     31
