BASE_RV32ZICOND_PRE = ${ISA}32-zicond-
BASE_RV32ZICOND_PATH = ${PRJ_DIR}src/test/rv32zicond
BASE_RV32ZICOND_CFLAGS = -march=rv32i_zicond -mabi=ilp32 -DXLEN=32
BASE_RV32ZICOND_CFLAGS += ${CFLAGS}
BASE_RV32ZICOND_ASM =	czeroeqz \
											czeronez


all: start ${BASE_RV32ZICOND_ASM}

start:
	${CC} ${BASE_RV32ZICOND_CFLAGS} -c ${PRJ_DIR}src/hw/${HW_CFG}/start.S -o ${PRJ_DIR}obj/start.o
	${CC} ${BASE_RV32ZICOND_CFLAGS} -c ${PRJ_DIR}src/hw/${HW_CFG}/hw.S -o ${PRJ_DIR}obj/${HW_CFG}.o

${BASE_RV32ZICOND_ASM}:
	${CC} ${BASE_RV32ZICOND_CFLAGS} -c ${BASE_RV32ZICOND_PATH}/asm/$@.S -o ${PRJ_DIR}obj/${BASE_RV32ZICOND_PRE}$@.o
	${LD} ${BASE_RV32ZICOND_CFLAGS} -T ${PRJ_DIR}src/hw/${HW_CFG}/script.ld ${PRJ_DIR}obj/start.o ${PRJ_DIR}obj/${HW_CFG}.o ${PRJ_DIR}obj/${BASE_RV32ZICOND_PRE}$@.o -o ${PRJ_DIR}elf/${BASE_RV32ZICOND_PRE}$@.elf
	${TOOLCHAIN}-objdump -D ${PRJ_DIR}elf/${BASE_RV32ZICOND_PRE}$@.elf > ${PRJ_DIR}lst/${BASE_RV32ZICOND_PRE}$@.lst -M numeric
	${TOOLCHAIN}-objcopy ${BOOT_SECTIONS} ${PRJ_DIR}elf/${BASE_RV32ZICOND_PRE}$@.elf ${PRJ_DIR}elf/${BASE_RV32ZICOND_PRE}$@.boot8.elf
	python3 ${ELF2HEX} --input ${PRJ_DIR}elf/${BASE_RV32ZICOND_PRE}$@.boot8.elf --output ${PRJ_DIR}hex/${BASE_RV32ZICOND_PRE}$@.boot8.hex --offset ${BOOT_OFFSET} --wide 16 --word 1
