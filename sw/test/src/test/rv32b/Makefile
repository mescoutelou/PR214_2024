BASE_RV32B_PATH = ${PRJ_DIR}src/test/rv32b
BASE_RV32B_CFLAGS = -march=rv32i -mabi=ilp32 -DXLEN=32
BASE_RV32B_CFLAGS += ${CFLAGS}

BASE_RV32ZBA_PRE = ${ISA}32-zba-
BASE_RV32ZBA_CFLAGS = -march=rv32i_zba -mabi=ilp32 -DXLEN=32
BASE_RV32ZBA_CFLAGS += ${CFLAGS}
BASE_RV32ZBA_ASM =	sh1add \
										sh2add \
										sh3add

BASE_RV32ZBB_PRE = ${ISA}32-zbb-
BASE_RV32ZBB_CFLAGS = -march=rv32i_zbb -mabi=ilp32 -DXLEN=32
BASE_RV32ZBB_CFLAGS += ${CFLAGS}
BASE_RV32ZBB_ASM =	andn orn xnor \
										clz ctz cpop \
										max maxu \
										min minu \
										sextb sexth zexth \
										rol ror rori \
										orcb rev8

BASE_RV32ZBS_PRE = ${ISA}32-zbs-
BASE_RV32ZBS_CFLAGS = -march=rv32i_zbs -mabi=ilp32 -DXLEN=32
BASE_RV32ZBS_CFLAGS += ${CFLAGS}
BASE_RV32ZBS_ASM =	bclr bclri \
										bext bexti \
										binv binvi \
										bset bseti


all: start ${BASE_RV32ZBA_ASM} ${BASE_RV32ZBB_ASM} ${BASE_RV32ZBS_ASM}

start:
	${CC} ${BASE_RV32B_CFLAGS} -c ${PRJ_DIR}src/hw/${HW_CFG}/start.S -o ${PRJ_DIR}obj/start.o
	${CC} ${BASE_RV32B_CFLAGS} -c ${PRJ_DIR}src/hw/${HW_CFG}/hw.S -o ${PRJ_DIR}obj/${HW_CFG}.o

${BASE_RV32ZBA_ASM}:
	${CC} ${BASE_RV32ZBA_CFLAGS} -c ${BASE_RV32B_PATH}/asm/$@.S -o ${PRJ_DIR}obj/${BASE_RV32ZBA_PRE}$@.o
	${LD} ${BASE_RV32ZBA_CFLAGS} -T ${PRJ_DIR}src/hw/${HW_CFG}/script.ld ${PRJ_DIR}obj/start.o ${PRJ_DIR}obj/${HW_CFG}.o ${PRJ_DIR}obj/${BASE_RV32ZBA_PRE}$@.o -o ${PRJ_DIR}elf/${BASE_RV32ZBA_PRE}$@.elf
	${TOOLCHAIN}-objdump -D ${PRJ_DIR}elf/${BASE_RV32ZBA_PRE}$@.elf > ${PRJ_DIR}lst/${BASE_RV32ZBA_PRE}$@.lst -M numeric
	${TOOLCHAIN}-objcopy ${BOOT_SECTIONS} ${PRJ_DIR}elf/${BASE_RV32ZBA_PRE}$@.elf ${PRJ_DIR}elf/${BASE_RV32ZBA_PRE}$@.boot8.elf
	python3 ${ELF2HEX} --input ${PRJ_DIR}elf/${BASE_RV32ZBA_PRE}$@.boot8.elf --output ${PRJ_DIR}hex/${BASE_RV32ZBA_PRE}$@.boot8.hex --offset ${BOOT_OFFSET} --wide 16 --word 1

${BASE_RV32ZBB_ASM}:
	${CC} ${BASE_RV32ZBB_CFLAGS} -c ${BASE_RV32B_PATH}/asm/$@.S -o ${PRJ_DIR}obj/${BASE_RV32ZBB_PRE}$@.o
	${LD} ${BASE_RV32ZBB_CFLAGS} -T ${PRJ_DIR}src/hw/${HW_CFG}/script.ld ${PRJ_DIR}obj/start.o ${PRJ_DIR}obj/${HW_CFG}.o ${PRJ_DIR}obj/${BASE_RV32ZBB_PRE}$@.o -o ${PRJ_DIR}elf/${BASE_RV32ZBB_PRE}$@.elf
	${TOOLCHAIN}-objdump -D ${PRJ_DIR}elf/${BASE_RV32ZBB_PRE}$@.elf > ${PRJ_DIR}lst/${BASE_RV32ZBB_PRE}$@.lst -M numeric
	${TOOLCHAIN}-objcopy ${BOOT_SECTIONS} ${PRJ_DIR}elf/${BASE_RV32ZBB_PRE}$@.elf ${PRJ_DIR}elf/${BASE_RV32ZBB_PRE}$@.boot8.elf
	python3 ${ELF2HEX} --input ${PRJ_DIR}elf/${BASE_RV32ZBB_PRE}$@.boot8.elf --output ${PRJ_DIR}hex/${BASE_RV32ZBB_PRE}$@.boot8.hex --offset ${BOOT_OFFSET} --wide 16 --word 1

${BASE_RV32ZBS_ASM}:
	${CC} ${BASE_RV32ZBS_CFLAGS} -c ${BASE_RV32B_PATH}/asm/$@.S -o ${PRJ_DIR}obj/${BASE_RV32ZBS_PRE}$@.o
	${LD} ${BASE_RV32ZBS_CFLAGS} -T ${PRJ_DIR}src/hw/${HW_CFG}/script.ld ${PRJ_DIR}obj/start.o ${PRJ_DIR}obj/${HW_CFG}.o ${PRJ_DIR}obj/${BASE_RV32ZBS_PRE}$@.o -o ${PRJ_DIR}elf/${BASE_RV32ZBS_PRE}$@.elf
	${TOOLCHAIN}-objdump -D ${PRJ_DIR}elf/${BASE_RV32ZBS_PRE}$@.elf > ${PRJ_DIR}lst/${BASE_RV32ZBS_PRE}$@.lst -M numeric
	${TOOLCHAIN}-objcopy ${BOOT_SECTIONS} ${PRJ_DIR}elf/${BASE_RV32ZBS_PRE}$@.elf ${PRJ_DIR}elf/${BASE_RV32ZBS_PRE}$@.boot8.elf
	python3 ${ELF2HEX} --input ${PRJ_DIR}elf/${BASE_RV32ZBS_PRE}$@.boot8.elf --output ${PRJ_DIR}hex/${BASE_RV32ZBS_PRE}$@.boot8.hex --offset ${BOOT_OFFSET} --wide 16 --word 1
