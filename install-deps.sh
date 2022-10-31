#!/bin/bash

. /etc/os-release

if [[ "Arch Linux" != "$NAME" ]]; then
  echo "require arch linux to run this script"
  exit 1
fi

pacman -Syu --needed --noconfirm \
  git base-devel \
  python3 flex bison swig python-setuptools \
  gptfdisk arch-install-scripts

if [[ ! -d repos/u-boot ]]; then
  git submodule update --init
fi
