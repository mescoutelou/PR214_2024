BASE_RV64M_PRE = ${ISA}64-m-
BASE_RV32M_PATH = ${PRJ_DIR}src/test/rv32m
BASE_RV64M_PATH = ${PRJ_DIR}src/test/rv64m
BASE_RV64M_CFLAGS = -march=rv64im -mabi=lp64 -DXLEN=64
BASE_RV64M_CFLAGS += ${CFLAGS}
BASE_RV32M_ASM = 	mul \
									mulh mulhsu mulhu \
									div divu \
									rem remu

BASE_RV64M_ASM = 	


all: start ${BASE_RV32M_ASM} ${BASE_RV64M_ASM}

start:
	${CC} ${BASE_RV64M_CFLAGS} -c ${PRJ_DIR}src/hw/${HW_CFG}/start.S -o ${PRJ_DIR}obj/start.o
	${CC} ${BASE_RV64M_CFLAGS} -c ${PRJ_DIR}src/hw/${HW_CFG}/hw.S -o ${PRJ_DIR}obj/${HW_CFG}.o

${BASE_RV32M_ASM}:
	${CC} ${BASE_RV64M_CFLAGS} -c ${BASE_RV32M_PATH}/asm/$@.S -o ${PRJ_DIR}obj/${BASE_RV64M_PRE}$@.o
	${LD} ${BASE_RV64M_CFLAGS} -T ${PRJ_DIR}src/hw/${HW_CFG}/script.ld ${PRJ_DIR}obj/start.o ${PRJ_DIR}obj/${HW_CFG}.o ${PRJ_DIR}obj/${BASE_RV64M_PRE}$@.o -o ${PRJ_DIR}elf/${BASE_RV64M_PRE}$@.elf
	${TOOLCHAIN}-objdump -D ${PRJ_DIR}elf/${BASE_RV64M_PRE}$@.elf > ${PRJ_DIR}lst/${BASE_RV64M_PRE}$@.lst -M numeric
	${TOOLCHAIN}-objcopy ${BOOT_SECTIONS} ${PRJ_DIR}elf/${BASE_RV64M_PRE}$@.elf ${PRJ_DIR}elf/${BASE_RV64M_PRE}$@.boot8.elf
	python3 ${ELF2HEX} --input ${PRJ_DIR}elf/${BASE_RV64M_PRE}$@.boot8.elf --output ${PRJ_DIR}hex/${BASE_RV64M_PRE}$@.boot8.hex --offset ${BOOT_OFFSET} --wide 16 --word 1

${BASE_RV64M_ASM}:
	${CC} ${BASE_RV64M_CFLAGS} -c ${BASE_RV64M_PATH}/asm/$@.S -o ${PRJ_DIR}obj/${BASE_RV64M_PRE}$@.o
	${LD} ${BASE_RV64M_CFLAGS} -T ${PRJ_DIR}src/hw/${HW_CFG}/script.ld ${PRJ_DIR}obj/start.o ${PRJ_DIR}obj/${HW_CFG}.o ${PRJ_DIR}obj/${BASE_RV64M_PRE}$@.o -o ${PRJ_DIR}elf/${BASE_RV64M_PRE}$@.elf
	${TOOLCHAIN}-objdump -D ${PRJ_DIR}elf/${BASE_RV64M_PRE}$@.elf > ${PRJ_DIR}lst/${BASE_RV64M_PRE}$@.lst -M numeric
	${TOOLCHAIN}-objcopy ${BOOT_SECTIONS} ${PRJ_DIR}elf/${BASE_RV64M_PRE}$@.elf ${PRJ_DIR}elf/${BASE_RV64M_PRE}$@.boot8.elf
	python3 ${ELF2HEX} --input ${PRJ_DIR}elf/${BASE_RV64M_PRE}$@.boot8.elf --output ${PRJ_DIR}hex/${BASE_RV64M_PRE}$@.boot8.hex --offset ${BOOT_OFFSET} --wide 16 --word 1
