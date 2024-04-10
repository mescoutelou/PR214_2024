PRJ_DIR = `pwd`

VERILATOR_ARGS = --x-initial unique --x-assign unique
# VERILATOR_ARGS += --trace-depth 1 

sys-build:
	mkdir -p sim/sys/vcd
	sbt "runMain emmk.sys.Sys -o=${PRJ_DIR}/sim/sys/src"
	verilator ${VERILATOR_ARGS} -Wno-WIDTH -Wno-CMPCONST --trace -cc -I${PRJ_DIR}/sim/sys/src/ ${PRJ_DIR}/sim/sys/src/Sys.sv ${PRJ_DIR}/sim/sys/src/ram.sv --exe --Mdir ${PRJ_DIR}/sim/sys/obj --build ${PRJ_DIR}/sim/sys/sys.cpp
	cp ${PRJ_DIR}/sim/sys/obj/VSys ${PRJ_DIR}/sim/sys/sys-exe

clean:
	rm -rf output/
	rm -rf target/
	rm -rf sim/*/obj/
	rm -rf sim/*/src/
	rm -rf sim/*/vcd/
	rm -rf test_run_dir
	rm -rf *.json
	sbt clean cleanFiles
