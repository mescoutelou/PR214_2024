SBT_VERSION="1.8.0"
FIRTOOL_VERSION="1.58.0"
GTKWAVE_VERSION="3.3.117"

mkdir tools/
cd tools/

wget https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz
tar -xvzf  sbt-${SBT_VERSION}.tgz
rm -f sbt-${SBT_VERSION}.tgz

wget https://github.com/llvm/circt/releases/download/firtool-${FIRTOOL_VERSION}/firrtl-bin-linux-x64.tar.gz
tar -xvzf firrtl-bin-linux-x64.tar.gz
mv firtool-${FIRTOOL_VERSION} firtool
rm -f firrtl-bin-linux-x64.tar.gz

wget https://gtkwave.sourceforge.net/gtkwave-${GTKWAVE_VERSION}.tar.gz
tar -xvzf gtkwave-${GTKWAVE_VERSION}.tar.gz
mv gtkwave-${GTKWAVE_VERSION} gtkwave
rm -f gtkwave-${GTKWAVE_VERSION}.tar.gz

cd .. 