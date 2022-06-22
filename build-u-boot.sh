CWD=$PWD
cd $PWD/repos/u-boot/
git clean -fdx
git reset --hard origin/master
git apply $CWD/patches/u-boot/riscv-Fix-build-against-binutils-2.38.diff
git apply $CWD/patches/u-boot/0005-board-sifive-spl-Set-remote-thermal-of-TMP451-to-85-.patch
export OPENSBI=$CWD/install/share/opensbi/lp64/generic/firmware/fw_dynamic.bin
make sifive_unmatched_defconfig
make -j16
