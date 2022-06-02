CWD=$PWD
cd $PWD/repos/u-boot/
git clean -fdx
git reset --hard origin/master
git apply $CWD/patches/u-boot/riscv-Fix-build-against-binutils-2.38.diff
export OPENSBI=$CWD/install/share/opensbi/lp64/generic/firmware/fw_dynamic.bin
make sifive_unmatched_defconfig
make -j16
