MAKE_PATH := ${abspath ${lastword ${MAKEFILE_LIST}}}
PRJ_DIR := ${dir ${MAKE_PATH}}
HW_CFG = WAESP
ISA = riscv
TOOLCHAIN = riscv64-unknown-elf
ROM_SECTIONS = --only-section .rodata* --only-section .text*
ROM_OFFSET = 0x04000000

NAME = bare
CC = ${TOOLCHAIN}-gcc
LD = ${TOOLCHAIN}-gcc
CFLAGS = -O2 -nostartfiles -fstrict-volatile-bitfields
CFLAGS += -Woverflow 
CFLAGS += -march=rv32if -mabi=ilp32 -DXLEN=32
ELF2HEX = elf2hex.py

bare: build-dir
	${CC} ${CFLAGS} -c src/bare.S -o obj/bare.o
	${CC} ${CFLAGS} -c src/func.c -o obj/func.o
	${LD} ${CFLAGS} -T script.ld obj/bare.o obj/func.o -o elf/bare.elf
	${TOOLCHAIN}-objdump -D elf/bare.elf > lst/bare.lst -M numeric
	${TOOLCHAIN}-objcopy ${ROM_SECTIONS} elf/bare.elf elf/bare.rom8.elf
	python3 ${ELF2HEX} --input elf/bare.rom8.elf --output hex/bare.rom8.hex --offset ${ROM_OFFSET} --wide 16 --word 1

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