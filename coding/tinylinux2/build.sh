#!/bin/sh

git clone https://github.com/torvalds/linux --depth 1
cd linux
cp ../.config .config
make -j$(nproc)

cd ..

OUT=./linux/arch/x86/boot/bzImage

wget http://landley.net/bin/toybox/latest/toybox-i686

chmod +x toybox-i686

mkdir -p initrd/bin
mv toybox-i686 initrd/bin/toybox

BIN=./toybox
DEST=./

cd initrd/bin

for applet in $($BIN); do
    echo "Copying $applet"
    ln -sf "$BIN" "$DEST/$applet"
done

cd ../..

function cleanup {
    umount mnt
}

trap cleanup EXIT
set -e

dd if=/dev/zero of=boot.img bs=512 count=2880

mkfs -t fat boot.img

syslinux ./boot.img

(cd initrd && find . | cpio -o -H newc | lzma > ../initramfs.cpio.lzma && cd ../)

mkdir -p mnt
sudo mount boot.img mnt
sudo cp {bzImage,initramfs.cpio.lzma} mnt
sudo cp syslinux.cfg mnt/syslinux.cfg
sudo umount mnt

qemu-system-x86_64 \
    -drive file=boot.img,format=raw
