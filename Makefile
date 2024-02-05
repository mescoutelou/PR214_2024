PRJ_DIR = `pwd`

VERILATOR_ARGS = --x-initial unique --x-assign unique
# VERILATOR_ARGS += --trace-depth 1 

sim-build:
	sbt "runMain prj.top.Top -o=${PRJ_DIR}/sim/src"
	verilator ${VERILATOR_ARGS} -Wno-WIDTH -Wno-CMPCONST --trace -cc -I${PRJ_DIR}/sim/src/ ${PRJ_DIR}/sim/src/Top.sv ${PRJ_DIR}/sim/src/ram.sv --exe --Mdir ${PRJ_DIR}/sim/obj --build ${PRJ_DIR}/sim/top.cpp
	cp ${PRJ_DIR}/sim/obj/VTop ${PRJ_DIR}/sim/sim-exe

clean:
	rm -rf output/
	rm -rf target/
	rm -rf sim/obj/
	rm -rf sim/src/
	rm -rf sim/*.vcd
	rm -rf test_run_dir
	rm -rf *.json
	sbt clean cleanFiles
