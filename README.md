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
./install-deps.sh
./build-opensbi.sh
./build-u-boot.sh
./mk-image.sh
```

> Addtional:
>
> If you want to cross-compile on x86_64 machine, install riscv64-linux-gnu-gcc, then
> add option `cross-compile` to all the build script:
>
> ```text
> ./build-opensbi.sh cross-compile
> ./build-u-boot.sh cross-compile
> ./mk-image.sh cross-compile
> ```

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
2. 然后跟着官方的安装教程来：<https://wiki.archlinux.org/title/Installation_guide>
  * 硬盘分成一整块就行，不需要 swap 和 boot 分区
  * 需要自己手动启动 networkd 服务： `systemctl start systemd-networkd && systemctl start systemd-resolvd`
3. 安装好之后打开 `/boot/extlinux/extlinux.conf` 文件，
复制两份原来的启动 label，隔一行粘贴一份。然后做一些修改：
  * 将原来的 label 改成 `mmc`，menu 改成 `Arch Linux (MMC)`，这个 label 就是用来引导我们进入当前的 SD 卡的系统的。
  * 复制一份 label 配置，把 label 改成 `arch`，menu label 改成 `Arch Linux`，root 部分改成 `root=/dev/nvme0n1p1`，
  initrd 改成 `/boot/initramfs-linux.img`，这个 label 用来之后引导进入 NVME 的系统。
  * 复制一份 label 配置，把 label 改成 `arch-fallback`，menu label 改成 `Arch Linux (Fallback)`，root 部分改成
  `root=/dev/nvme0n1p1`，这个 label 用来第一次进入系统。
4. 重启之后，第一次启动需要用 Arch Linux (Fallback) 来进入系统。

## 使用 Docker 构建

启动 dockerd，执行 `mkin-docker` 脚本。生成的镜像文件会放在 images/ 目录下。
