CWD=$PWD
cd $PWD/repos/u-boot/
git clean -fdx
git reset --hard origin/master
git apply $CWD/patches/u-boot/riscv-Fix-build-against-binutils-2.38.diff
git apply $CWD/patches/u-boot/0002-board-sifive-spl-Initialized-the-PWM-setting-in-the-.patch
git apply $CWD/patches/u-boot/0003-board-sifive-Set-LED-s-color-to-purple-in-the-U-boot.patch
# can't patch unmatched.h git apply $CWD/patches/u-boot/0004-board-sifive-Set-LED-s-color-to-blue-before-jumping-.patch
git apply $CWD/patches/u-boot/0005-board-sifive-spl-Set-remote-thermal-of-TMP451-to-85-.patch
git apply $CWD/patches/u-boot/0007-riscv-sifive-unmatched-disable-FDT-and-initrd-reloca.patch
export OPENSBI=$CWD/install/share/opensbi/lp64/generic/firmware/fw_dynamic.bin
make sifive_unmatched_defconfig
make -j16
