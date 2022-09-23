. $PWD/utils.sh

mkdir -p build
mkdir -p install

BUILD_FLAG="BUILD_INFO=y PLATFORM=generic"

if is_cross_compile "$@"; then
  echo "Using cross-compile options"
  BUILD_FLAG="$BUILD_FLAG CROSS_COMPILE=riscv64-linux-gnu-"
fi

make -C $PWD/repos/opensbi/ O=$PWD/build I=$PWD/install $BUILD_FLAG install
