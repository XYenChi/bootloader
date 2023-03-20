#!/bin/bash

. /etc/os-release

if [[ "Arch Linux" != "$NAME" ]]; then
  echo "require arch linux to run this script"
  exit 1
fi

echo '[archlinuxcn]
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch' >> /etc/pacman.conf
pacman-key --init
pacman -Syu --noconfirm archlinuxcn-keyring

pacman -Syu --needed --noconfirm \
  git base-devel curl\
  python3 flex bison swig python-setuptools \
  gptfdisk arch-install-scripts riscv64-linux-gnu-gcc qemu-user-static-binfmt devtools-riscv64
