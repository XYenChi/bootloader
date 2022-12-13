# bootloader

## Pre-built Image

在 [Action](https://github.com/XYenChi/bootloader/actions) 页面里选择一个构建成功的 workflow，点击进去，在页面最下方的 Artifacts 栏下载镜像。

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

```bash
./install-deps.sh
./build-opensbi.sh
./build-u-boot.sh
./mk-image.sh
```

> Addtional:
>
> If you want to cross-compile on x86_64 machine, install riscv64-linux-gnu-gcc, then
> add option `cross-compile` to all the build script:

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

1. 启用板子，等 kernel boot 之后，登录 root 账户，密码默认是 `archriscv`。
2. 可以使用装机脚本 [`install-system-to-ssd.sh`](./install-system-to-ssd.sh)，或者跟着官方教程来手动安装：
然后跟着官方的安装教程来：<https://wiki.archlinux.org/title/Installation_guide>。
  * 硬盘分成一整块就行，不需要 swap 和 boot 分区
  * 手动安装的话需要手动创建 `/mnt/boot/extlinux/extlinux.conf` 文件，具体内容可以参考装机脚本
  * 还要记得复制一份 dtb 文件。

## 使用 Docker 构建

启动 dockerd，执行 `mkin-docker` 脚本。生成的镜像文件会放在 images/ 目录下。
