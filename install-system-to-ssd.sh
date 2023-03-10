#!/bin/bash

DEVICE=${DEVICE:-/dev/nvme0n1}

# Create a partition that occupy every space on the disk
sgdisk --clear --new=1:0:0 $DEVICE
mkfs.ext4 ${DEVICE}p1
mount ${DEVICE}p1 /mnt

pacstrap -K /mnt base linux linux-firmware vim openssh sudo

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
arch-chroot /mnt hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
arch-chroot /mnt locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

tee -a /mnt/etc/systemd/network/end0.network << END
[Match]
Name=end0
[Network]
DHCP=yes
END

mkdir -p /mnt/boot/extlinux
tee -a /mnt/boot/extlinux/extlinux.conf << END
default arch
menu title U-Boot menu
prompt 0
timeout 50

label arch
  menu label Arch Linux
  linux /boot/vmlinuz-linux
  initrd /boot/initramfs-linux.img
  fdtdir /boot/dtbs/
  append root=${DEVICE}p1 rw earlycon

label arch-fallback
  menu label Arch Linux (Fallback)
  linux /boot/vmlinuz-linux
  initrd /boot/initramfs-linux-fallback.img
  fdtdir /boot/dtbs/
  append root=${DEVICE}p1 rw earlycon
END
cp -r /mnt/usr/share/dtbs/*-arch*/ /mnt/boot/dtbs

echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" >> /mnt/etc/sudoers

ensure_services=(systemd-timesyncd systemd-networkd systemd-resolved sshd)
for service in ${ensure_services[@]}; do
	arch-chroot /mnt systemctl enable "$service"
done

usermod --root $(realpath /mnt) --password $(openssl passwd -6 "archriscv") root

cp add-packager.sh /mnt/root

umount -l /mnt
