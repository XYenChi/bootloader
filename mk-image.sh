. $PWD/utils.sh

IMAGE_FILE="image-$(date --rfc-3339=date).raw"

# truncate will not allocate new space if file is already exist,
# which might lead to some unexpected issue.
[[ -f $IMAGE_FILE ]] && rm -f $IMAGE_FILE

# create a file with 2G size
truncate -s 2G $IMAGE_FILE

# create partition into it
sgdisk -g --clear -a 1 \
  --new=1:34:2081:       --change-name=1:spl    --typecode=1:5B193300-FC78-40CD-8002-E86C45580B47 \
  --new=2:2082:16383:    --change-name=2:uboot  --typecode=2:2E54B353-1271-4842-806F-E436D6AF6985 \
  --new=3:16384:-0       --change-name=3:rootfs --attributes=3:set:2  \
  $IMAGE_FILE

# write u-boot into it
dd if=$PWD/repos/u-boot/spl/u-boot-spl.bin of=$IMAGE_FILE bs=512 seek=34 conv=sync,notrunc
dd if=$PWD/repos/u-boot/u-boot.itb of=$IMAGE_FILE bs=512 seek=2082 conv=sync,notrunc

losetup -D
LODEV=$(losetup -f --show -P $IMAGE_FILE)

if [[ -f /.dockerenv ]]; then
  # Issue: https://github.com/moby/moby/issues/27886#issuecomment-417074845
  PARTITIONS=$(lsblk --raw --output "MAJ:MIN" --noheadings ${LODEV} | tail -n +2)
  COUNTER=1
  for i in $PARTITIONS; do
    MAJ=$(echo $i | cut -d: -f1)
    MIN=$(echo $i | cut -d: -f2)
    if [[ ! -e "${LODEV}p${COUNTER}" ]]; then mknod ${LODEV}p${COUNTER} b $MAJ $MIN; fi
    COUNTER=$((COUNTER + 1))
  done
fi

mkfs.ext4 "${LODEV}p3"
mkdir rootfs
mount "${LODEV}p3" rootfs/

if is_cross_compile "$@"; then
  pacstrap \
      -C ./pacman-extra-riscv64.conf \
      -M \
      ./rootfs \
      base linux linux-firmware vim arch-install-scripts
else
  pacstrap rootfs base linux linux-firmware vim arch-install-scripts
fi

usermod --root $(realpath ./rootfs) --password $(openssl passwd -6 "archriscv") root

echo "pts/0\n" >> rootfs/etc/securetty
mkdir rootfs/boot/extlinux
tee -a rootfs/boot/extlinux/extlinux.conf << END
default arch
menu title U-Boot menu
prompt 0
timeout 50

label arch
        menu label Arch Linux
        linux /boot/vmlinuz-linux
        initrd /boot/initramfs-linux-fallback.img
        fdtdir /boot/dtbs/
        append root=/dev/mmcblk0p3 rw earlycon
END
cp -r rootfs/usr/share/dtbs/*-arch*/ rootfs/boot/dtbs
tee -a rootfs/etc/systemd/network/eth0.network << END
[Match]
Name=eth0
[Network]
DHCP=yes
END
cp /etc/pacman.conf rootfs/etc/pacman.conf

umount -l rootfs
rmdir rootfs
losetup -D
