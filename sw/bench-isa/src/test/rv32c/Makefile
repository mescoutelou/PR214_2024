BASE_RV32C_PRE = ${ISA}32-c-
BASE_RV32C_PATH = ${PRJ_DIR}src/test/rv32c
BASE_RV32C_CFLAGS = -march=rv32ic -mabi=ilp32 -DXLEN=32
BASE_RV32C_CFLAGS += ${CFLAGS}
BASE_RV32C_ASM =  caddi4spn caddi16sp \
									clw clwsp \
									csw cswsp \
									caddi \
									cli clui \
									csrli csrai cslli \
									candi \
									cadd csub cmv \
									cxor cor cand \
									cjal cj \
									cjalr cjr \
									cbeqz cbnez

BASE_RV32C_C =	fibonacci \
								matrix-add \
								matrix-mul

all: start ${BASE_RV32C_ASM} ${BASE_RV32C_C}

start:
	${CC} ${BASE_RV32C_CFLAGS} -c ${PRJ_DIR}src/hw/${HW_CFG}/start.S -o ${PRJ_DIR}obj/start.o
	${CC} ${BASE_RV32C_CFLAGS} -c ${PRJ_DIR}src/hw/${HW_CFG}/hw.S -o ${PRJ_DIR}obj/${HW_CFG}.o

${BASE_RV32C_ASM}:
	${CC} ${BASE_RV32C_CFLAGS} -c ${BASE_RV32C_PATH}/asm/$@.S -o ${PRJ_DIR}obj/${BASE_RV32C_PRE}$@.o
	${LD} ${BASE_RV32C_CFLAGS} -T ${PRJ_DIR}src/hw/${HW_CFG}/script.ld ${PRJ_DIR}obj/start.o ${PRJ_DIR}obj/${HW_CFG}.o ${PRJ_DIR}obj/${BASE_RV32C_PRE}$@.o -o ${PRJ_DIR}elf/${BASE_RV32C_PRE}$@.elf
	${TOOLCHAIN}-objdump -D ${PRJ_DIR}elf/${BASE_RV32C_PRE}$@.elf > ${PRJ_DIR}lst/${BASE_RV32C_PRE}$@.lst -M numeric
	${TOOLCHAIN}-objcopy ${BOOT_SECTIONS} ${PRJ_DIR}elf/${BASE_RV32C_PRE}$@.elf ${PRJ_DIR}elf/${BASE_RV32C_PRE}$@.boot8.elf
	python3 ${ELF2HEX} --input ${PRJ_DIR}elf/${BASE_RV32C_PRE}$@.boot8.elf --output ${PRJ_DIR}hex/${BASE_RV32C_PRE}$@.boot8.hex --offset ${BOOT_OFFSET} --wide 16 --word 1
	
${BASE_RV32C_C}:
	${CC} ${BASE_RV32C_CFLAGS} -c ${BASE_RV32C_PATH}/c/$@.c -o ${PRJ_DIR}obj/${BASE_RV32C_PRE}$@.o
	${LD} ${BASE_RV32C_CFLAGS} -T ${PRJ_DIR}src/hw/${HW_CFG}/script.ld ${PRJ_DIR}obj/start.o ${PRJ_DIR}obj/${HW_CFG}.o ${PRJ_DIR}obj/${BASE_RV32C_PRE}$@.o -o ${PRJ_DIR}elf/${BASE_RV32C_PRE}$@.elf
	${TOOLCHAIN}-objdump -D ${PRJ_DIR}elf/${BASE_RV32C_PRE}$@.elf > ${PRJ_DIR}lst/${BASE_RV32C_PRE}$@.lst -M numeric
	${TOOLCHAIN}-objcopy ${BOOT_SECTIONS} ${PRJ_DIR}elf/${BASE_RV32C_PRE}$@.elf ${PRJ_DIR}elf/${BASE_RV32C_PRE}$@.boot8.elf
	python3 ${ELF2HEX} --input ${PRJ_DIR}elf/${BASE_RV32C_PRE}$@.boot8.elf --output ${PRJ_DIR}hex/${BASE_RV32C_PRE}$@.boot8.hex --offset ${BOOT_OFFSET} --wide 16 --word 1
	
