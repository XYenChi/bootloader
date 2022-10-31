#!/bin/bash

. /etc/os-release

if [[ "Arch Linux" != "$NAME" ]]; then
  echo "require arch linux to run this script"
  exit 1
fi

pacman -Syu --needed --noconfirm \
  git base-devel curl\
  python3 flex bison swig python-setuptools \
  gptfdisk arch-install-scripts riscv64-linux-gnu-gcc

curl -fLo pacman-extra-riscv64.conf \
  "https://raw.githubusercontent.com/archlinuxcn/repo/master/archlinuxcn/devtools-riscv64/pacman-extra-riscv64.conf"
