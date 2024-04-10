MAKE_PATH := ${abspath ${lastword ${MAKEFILE_LIST}}}
PRJ_DIR := ${dir ${MAKE_PATH}}
HW_CFG = WAESP
ISA = riscv
TOOLCHAIN = riscv64-unknown-elf
ROM_SECTIONS = --only-section .rodata* --only-section .text*
ROM_OFFSET = 0x04000000

NAME = test
CC = ${TOOLCHAIN}-gcc
LD = ${TOOLCHAIN}-gcc
CFLAGS = -O1 -nostartfiles -fstrict-volatile-bitfields
CFLAGS += -Woverflow 
CFLAGS += -march=rv32if -mabi=ilp32 -DXLEN=32
ELF2HEX = elf2hex.py

test: build-dir
	${CC} ${CFLAGS} -c src/test.S -o obj/test.o
	${LD} ${CFLAGS} -T script.ld obj/test.o -o elf/test.elf
	${TOOLCHAIN}-objdump -D elf/test.elf > lst/test.lst -M numeric
	${TOOLCHAIN}-objcopy ${ROM_SECTIONS} elf/test.elf elf/test.rom8.elf
	python3 ${ELF2HEX} --input elf/test.rom8.elf --output hex/test.rom8.hex --offset ${ROM_OFFSET} --wide 16 --word 1

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