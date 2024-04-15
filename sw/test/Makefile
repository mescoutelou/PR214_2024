
MAKE_PATH := ${abspath ${lastword ${MAKEFILE_LIST}}}
PRJ_DIR := ${dir ${MAKE_PATH}}

HW_CFG = SYS
include src/hw/${HW_CFG}/Makefile

NAME = bench-isa
TOOLCHAIN = riscv64-unknown-elf
CC = ${TOOLCHAIN}-gcc
LD = ${TOOLCHAIN}-gcc
CFLAGS = -O1 -nostartfiles -fstrict-volatile-bitfields
CFLAGS += -Woverflow 
ELF2HEX = ${PRJ_DIR}/../bare/elf2hex.py

export TOOLCHAIN ISA PRJ_DIR CC CFLAGS LD ELF2HEX HW_CFG BOOT_SECTIONS BOOT_OFFSET

all: all32

all32: rv32i rv32m rv32a rv32c rv32b rv32zicond rv32zifencei

rv32i: build-dir
	@${MAKE} -C src/test/rv32i all

rv32m: build-dir
	@${MAKE} -C src/test/rv32m all

rv32a: build-dir
	@${MAKE} -C src/test/rv32a all

rv32c: build-dir
	@${MAKE} -C src/test/rv32c all

rv32b: build-dir
	@${MAKE} -C src/test/rv32b all

rv32zicond:	build-dir
	@${MAKE} -C src/test/rv32zicond all
	
rv32zifencei:	build-dir
	@${MAKE} -C src/test/rv32zifencei all

rv64i: build-dir
	@${MAKE} -C src/test/rv64i all

rv64m: build-dir
	@${MAKE} -C src/test/rv64m all

build-dir:
	mkdir -p obj
	mkdir -p elf
	mkdir -p hex
	mkdir -p lst

clean:
	rm -rf obj
	rm -rf elf
	rm -rf hex
	rm -rf lst