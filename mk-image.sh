dd if=/dev/zero of=./image.raw bs=1M count=32
sudo sgdisk -g --clear -a 1 \
  --new=1:34:2081         --change-name=1:spl --typecode=1:5B193300-FC78-40CD-8002-E86C45580B47 \
  --new=2:2082:10273      --change-name=2:uboot  --typecode=2:2E54B353-1271-4842-806F-E436D6AF6985 \
  image.raw
dd if=$PWD/repos/u-boot/spl/u-boot-spl.bin of=image.raw bs=512 seek=34 conv=sync,notrunc
dd if=$PWD/repos/u-boot/u-boot.itb of=image.raw bs=512 seek=2082 conv=sync,notrunc
