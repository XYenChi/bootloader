. $PWD/utils.sh

CWD=$PWD
PREFIX=$PWD/patches/u-boot

cd $PWD/repos/u-boot/
git clean -fdx
git reset --hard origin/master

git apply $PREFIX/riscv-Fix-build-against-binutils-2.38.diff
git apply $PREFIX/0002-board-sifive-spl-Initialized-the-PWM-setting-in-the-.patch
git apply $PREFIX/0003-board-sifive-Set-LED-s-color-to-purple-in-the-U-boot.patch
# can't patch unmatched.h git apply $PREFIX/0004-board-sifive-Set-LED-s-color-to-blue-before-jumping-.patch
git apply $PREFIX/0005-board-sifive-spl-Set-remote-thermal-of-TMP451-to-85-.patch
git apply $PREFIX/0007-riscv-sifive-unmatched-disable-FDT-and-initrd-reloca.patch

export OPENSBI=$CWD/install/share/opensbi/lp64/generic/firmware/fw_dynamic.bin

BUILD_FLAG=""

if is_cross_compile "$@"; then
  echo "Using cross-compile options."
  BUILD_FLAG="$BUILD_FLAG CROSS_COMPILE=riscv64-linux-gnu-"
fi

make $BUILD_FLAG sifive_unmatched_defconfig
make $BUILD_FLAG -j16
