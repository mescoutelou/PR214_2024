BASE_RV32F_PRE = ${ISA}32-f-
BASE_RV32F_PATH = ${PRJ_DIR}src/test/rv32f
BASE_RV32F_CFLAGS = -march=rv32if -mabi=ilp32 -DXLEN=32
BASE_RV32F_CFLAGS += ${CFLAGS}
BASE_RV32F_ASM = 	fadds fsubs \
									fmins fmaxs

BASE_RV32F_C =	

all: start ${BASE_RV32F_ASM} ${BASE_RV32F_C}

start:
	${CC} ${BASE_RV32F_CFLAGS} -c ${PRJ_DIR}src/hw/${HW_CFG}/start.S -o ${PRJ_DIR}obj/start.o
	${CC} ${BASE_RV32F_CFLAGS} -c ${PRJ_DIR}src/hw/${HW_CFG}/hw.S -o ${PRJ_DIR}obj/${HW_CFG}.o

${BASE_RV32F_ASM}:
	${CC} ${BASE_RV32F_CFLAGS} -c ${BASE_RV32F_PATH}/asm/$@.S -o ${PRJ_DIR}obj/${BASE_RV32F_PRE}$@.o
	${LD} ${BASE_RV32F_CFLAGS} -T ${PRJ_DIR}src/hw/${HW_CFG}/script.ld ${PRJ_DIR}obj/start.o ${PRJ_DIR}obj/${HW_CFG}.o ${PRJ_DIR}obj/${BASE_RV32F_PRE}$@.o -o ${PRJ_DIR}elf/${BASE_RV32F_PRE}$@.elf
	${TOOLCHAIN}-objdump -D ${PRJ_DIR}elf/${BASE_RV32F_PRE}$@.elf > ${PRJ_DIR}lst/${BASE_RV32F_PRE}$@.lst -M numeric
	${TOOLCHAIN}-objcopy ${BOOT_SECTIONS} ${PRJ_DIR}elf/${BASE_RV32F_PRE}$@.elf ${PRJ_DIR}elf/${BASE_RV32F_PRE}$@.boot8.elf
	python3 ${ELF2HEX} --input ${PRJ_DIR}elf/${BASE_RV32F_PRE}$@.boot8.elf --output ${PRJ_DIR}hex/${BASE_RV32F_PRE}$@.boot8.hex --offset ${BOOT_OFFSET} --wide 16 --word 1
	
${BASE_RV32F_C}:
	${CC} ${BASE_RV32F_CFLAGS} -c ${BASE_RV32F_PATH}/c/$@.c -o ${PRJ_DIR}obj/${BASE_RV32F_PRE}$@.o
	${LD} ${BASE_RV32F_CFLAGS} -T ${PRJ_DIR}src/hw/${HW_CFG}/script.ld ${PRJ_DIR}obj/start.o ${PRJ_DIR}obj/${HW_CFG}.o ${PRJ_DIR}obj/${BASE_RV32F_PRE}$@.o -o ${PRJ_DIR}elf/${BASE_RV32F_PRE}$@.elf
	${TOOLCHAIN}-objdump -D ${PRJ_DIR}elf/${BASE_RV32F_PRE}$@.elf > ${PRJ_DIR}lst/${BASE_RV32F_PRE}$@.lst -M numeric
	${TOOLCHAIN}-objcopy ${BOOT_SECTIONS} ${PRJ_DIR}elf/${BASE_RV32F_PRE}$@.elf ${PRJ_DIR}elf/${BASE_RV32F_PRE}$@.boot8.elf
	python3 ${ELF2HEX} --input ${PRJ_DIR}elf/${BASE_RV32F_PRE}$@.boot8.elf --output ${PRJ_DIR}hex/${BASE_RV32F_PRE}$@.boot8.hex --offset ${BOOT_OFFSET} --wide 16 --word 1
	