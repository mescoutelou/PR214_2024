BASE_RV32A_PRE = ${ISA}32-a-
BASE_RV32A_PATH = ${PRJ_DIR}src/test/rv32a
BASE_RV32A_CFLAGS = -march=rv32ia -mabi=ilp32 -DXLEN=32
BASE_RV32A_CFLAGS += ${CFLAGS}
BASE_RV32A_ASM = 	lr-sc-w \
									amoswap-w \
									amoadd-w \
									amoxor-w \
									amoand-w \
									amoor-w \
									amomin-w amominu-w \
									amomax-w amomaxu-w

all: start ${BASE_RV32A_ASM}

start:
	${CC} ${BASE_RV32A_CFLAGS} -c ${PRJ_DIR}src/hw/${HW_CFG}/start.S -o ${PRJ_DIR}obj/start.o
	${CC} ${BASE_RV32A_CFLAGS} -c ${PRJ_DIR}src/hw/${HW_CFG}/hw.S -o ${PRJ_DIR}obj/${HW_CFG}.o

${BASE_RV32A_ASM}:
	${CC} ${BASE_RV32A_CFLAGS} -c ${BASE_RV32A_PATH}/asm/$@.S -o ${PRJ_DIR}obj/${BASE_RV32A_PRE}$@.o
	${LD} ${BASE_RV32A_CFLAGS} -T ${PRJ_DIR}src/hw/${HW_CFG}/script.ld ${PRJ_DIR}obj/start.o ${PRJ_DIR}obj/${HW_CFG}.o ${PRJ_DIR}obj/${BASE_RV32A_PRE}$@.o -o ${PRJ_DIR}elf/${BASE_RV32A_PRE}$@.elf
	${TOOLCHAIN}-objdump -D ${PRJ_DIR}elf/${BASE_RV32A_PRE}$@.elf > ${PRJ_DIR}lst/${BASE_RV32A_PRE}$@.lst -M numeric
	${TOOLCHAIN}-objcopy ${BOOT_SECTIONS} ${PRJ_DIR}elf/${BASE_RV32A_PRE}$@.elf ${PRJ_DIR}elf/${BASE_RV32A_PRE}$@.boot8.elf
	python3 ${ELF2HEX} --input ${PRJ_DIR}elf/${BASE_RV32A_PRE}$@.boot8.elf --output ${PRJ_DIR}hex/${BASE_RV32A_PRE}$@.boot8.hex --offset ${BOOT_OFFSET} --wide 16 --word 1
