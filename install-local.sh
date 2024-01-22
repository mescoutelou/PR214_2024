PROJECT_PATH=`pwd`
SBT_VERSION="1.8.0"
FIRTOOL_VERSION="1.58.0"
GTKWAVE_VERSION="3.3.117"
VERILATOR_VERSION="4.216"

mkdir tools/
cd tools/

# INSTALL SBT
wget https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz
tar -xvzf  sbt-${SBT_VERSION}.tgz
rm -f sbt-${SBT_VERSION}.tgz

# INSTALL FIRTOOL
wget https://github.com/llvm/circt/releases/download/firtool-${FIRTOOL_VERSION}/firrtl-bin-linux-x64.tar.gz
tar -xvzf firrtl-bin-linux-x64.tar.gz
mv firtool-${FIRTOOL_VERSION} firtool
rm -f firrtl-bin-linux-x64.tar.gz

# INSTALL GTKWAVE
wget https://gtkwave.sourceforge.net/gtkwave-${GTKWAVE_VERSION}.tar.gz
tar -xvzf gtkwave-${GTKWAVE_VERSION}.tar.gz
mv gtkwave-${GTKWAVE_VERSION} gtkwave
rm -f gtkwave-${GTKWAVE_VERSION}.tar.gz

# INSTALL VERILATOR
git clone https://github.com/verilator/verilator
unset VERILATOR_ROOT
cd verilator
git pull         
git checkout v${VERILATOR_VERSION}
autoconf         
./configure      
make -j `nproc`
cd .. 

# INSTALL RISC-V TOOLCHAIN
# git clone https://github.com/riscv-collab/riscv-gnu-toolchain.git
# cd riscv-gnu-toolchain
# ./configure --prefix=${PROJECT_PATH}/tools/riscv --with-arch=rv32imf --with-abi=ilp32f
# make
# cd ..

cd .. 