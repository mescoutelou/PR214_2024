PRJ_DIR = `pwd`

VERILATOR_ARGS = --x-initial unique --x-assign unique
# VERILATOR_ARGS += --trace-depth 1 

BENCH_I_LIST = 	riscv32-i-lui \
								riscv32-i-auipc \
								riscv32-i-jal \
								riscv32-i-jalr \
								riscv32-i-beq \
								riscv32-i-bne \
								riscv32-i-bge \
								riscv32-i-bgeu \
								riscv32-i-blt \
								riscv32-i-bltu \
								riscv32-i-lb \
								riscv32-i-lbu \
								riscv32-i-lh \
								riscv32-i-lhu \
								riscv32-i-lw \
								riscv32-i-sb \
								riscv32-i-sh \
								riscv32-i-sw \
								riscv32-i-add \
								riscv32-i-sub \
								riscv32-i-slt \
								riscv32-i-sltu \
								riscv32-i-xor \
								riscv32-i-or \
								riscv32-i-and \
								riscv32-i-sll \
								riscv32-i-srl \
								riscv32-i-sra \
								riscv32-i-addi \
								riscv32-i-slti \
								riscv32-i-sltiu \
								riscv32-i-xori \
								riscv32-i-ori \
								riscv32-i-andi \
								riscv32-i-slli \
								riscv32-i-srli \
								riscv32-i-srai \
								riscv32-i-app-empty \
								riscv32-i-app-loop \
								riscv32-i-app-hcf \
								riscv32-i-app-br-now \
								riscv32-i-app-array

BLACK=\033[1;30m
RED=\033[1;31m
GREEN=\033[1;32m
ORANGE=\033[1;33m
PURPLE=\033[1;35m
NOCOLOR=\033[1m

sys-build:
	mkdir -p sim/sys/vcd
	sbt "runMain emmk.sys.Sys -o=${PRJ_DIR}/sim/sys/src"
	verilator ${VERILATOR_ARGS} -Wno-WIDTH -Wno-CMPCONST --trace -cc -I${PRJ_DIR}/sim/sys/src/ ${PRJ_DIR}/sim/sys/src/Sys.sv ${PRJ_DIR}/sim/sys/src/ram.sv --exe --Mdir ${PRJ_DIR}/sim/sys/obj --build ${PRJ_DIR}/sim/sys.cpp
	cp ${PRJ_DIR}/sim/sys/obj/VSys ${PRJ_DIR}/sim/sys/sys-exe

${BENCH_I_LIST}:
	./sim/sys/sys-exe --rom sw/test/hex/$@.boot8.hex --vcd sim/sys/vcd/$@.vcd --ntrigger 2000 | tee -a ${PRJ_DIR}/sim/sys/test.log

sys-test-int: ${BENCH_I_LIST}

sys-test: sys-test-int
	@echo "${PURPLE}******************************${NOCOLOR}"
	@echo "${NOCOLOR}Generated test reports: `grep -ir "TEST REPORT" --include="test.log" sim/* | wc -l` ${NOCOLOR}"
	@echo "${RED}Failed: `grep -ir "TEST REPORT: FAILED" --include="test.log" sim/* | wc -l` ${NOCOLOR}"
	@echo "${GREEN}Success: `grep -ir "TEST REPORT: SUCCESS" --include="test.log" sim/* | wc -l` ${NOCOLOR}"
	@echo "${PURPLE}******************************${NOCOLOR}"

clean:
	rm -rf output/
	rm -rf target/
	rm -rf sim/sys/
	rm -rf test_run_dir
	rm -rf *.json
	sbt clean cleanFiles
