PRJ_DIR=`pwd`

export PATH=${PATH}:${PRJ_DIR}/tools/sbt/bin
export PATH=${PATH}:${PRJ_DIR}/tools/firtool/bin
export PATH=${PATH}:${PRJ_DIR}/tools/gtkwave/bin
export PATH=${PATH}:${PRJ_DIR}/tools/verilator/bin
export PATH=${PATH}:/opt/riscv/bin

export VERILATOR_ROOT=${PRJ_DIR}/tools/verilator/