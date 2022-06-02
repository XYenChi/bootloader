mkdir -p build
mkdir -p install
make -C $PWD/repos/opensbi/ O=$PWD/build I=$PWD/install BUILD_INFO=y PLATFORM=generic install
