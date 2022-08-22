# bootloader

## 脚本运行环境

1.使用 QEMU 运行的Archriscv（反正nspawn起的系统不行
2.使用archriscv的开发板
  [申请远程使用方法](https://github.com/felixonmars/archriscv-packages/wiki/%E5%9F%BA%E5%BB%BA%E7%94%B3%E8%AF%B7)   

## 构建

```bash
git clone https://github.com/XYenChi/bootloader.git
git submodule init && git submodule update
sh build-opensbi.sh
sh build-u-boot.sh
sh mk-image.sh
```

## 写入 SD 卡

..TODO

## 装机

此处挖一个脚本坑...
