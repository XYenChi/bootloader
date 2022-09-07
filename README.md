# bootloader

## 脚本运行环境

1. 使用 QEMU System 运行的 Arch RISC-V
2. 使用 archriscv 的开发板
  [申请远程使用方法](https://github.com/felixonmars/archriscv-packages/wiki/%E5%9F%BA%E5%BB%BA%E7%94%B3%E8%AF%B7)

## 构建

1. prerequisite

```bash
git clone https://github.com/XYenChi/bootloader.git
git submodule init && git submodule update

sudo pacman -S --needed \
       arch-install-scripts libarchive git base-devel qemu-img qemu-system-riscv
```

2. Build

```
sh install-deps.sh
sh build-opensbi.sh
sh build-u-boot.sh
sh mk-image.sh
```

### Addtional

- Run qemu-system

```bash
git clone https://github.com/Avimitin/archriscv-scriptlet-for-bootloader.git arch-qemu-system
cd arch-qemu-system
make build
./startqemu.sh
```

## 写入 SD 卡

```bash
# find your SD Card
fdisk -l

# Write the image to the whole disk
dd if=image.raw of=/dev/sda status=progress
```

> Remember to set the MSEL[0:3] to `1101`.

## 装机

此处挖一个脚本坑...
