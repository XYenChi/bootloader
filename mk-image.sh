. $PWD/utils.sh

# truncate will not allocate new space if file is already exist,
# which might lead to some unexpected issue.
[[ -f image.raw ]] && rm -f image.raw

# create a file with 2G size
truncate -s 2G image.raw

# create partition into it
sgdisk -g --clear -a 1 \
  --new=1:34:2081:       --change-name=1:spl    --typecode=1:5B193300-FC78-40CD-8002-E86C45580B47 \
  --new=2:2082:16383:    --change-name=2:uboot  --typecode=2:2E54B353-1271-4842-806F-E436D6AF6985 \
  --new=3:16384:-0       --change-name=3:rootfs --attributes=3:set:2  \
  image.raw

# write u-boot into it
dd if=$PWD/repos/u-boot/spl/u-boot-spl.bin of=image.raw bs=512 seek=34 conv=sync,notrunc
dd if=$PWD/repos/u-boot/u-boot.itb of=image.raw bs=512 seek=2082 conv=sync,notrunc

losetup -D
losetup -f -P image.raw
mkfs.ext4 /dev/loop0p3
mkdir rootfs
mount /dev/loop0p3 rootfs/

if is_cross_compile "$@"; then
  pacstrap \
      -C /usr/share/devtools/pacman-extra-riscv64.conf \
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
