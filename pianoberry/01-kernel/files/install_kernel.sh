#!/bin/bash

apt install -y /root/linux-image-6.6.50-rt42-v8-16k+_6.6.50-1_arm64.deb

export KERN=6.6.50-rt42-v8-16k+

KERNDIR=/boot/$KERN
CONFDIR=/boot
[[ -d /boot/firmware ]] && KERNDIR=/boot/firmware/$KERN && CONFDIR=/boot/firmware
mkdir -p /$KERNDIR/
cp -dr /usr/lib/linux-image-$KERN/* /$KERNDIR/
mv $KERNDIR/overlays $KERNDIR/o
[[ -d /usr/lib/linux-image-$KERN/broadcom ]] && cp -d /usr/lib/linux-image-$KERN/broadcom/* /$KERNDIR/
touch /$KERNDIR/o/README
cp /boot/vmlinuz-$KERN /$KERNDIR/
cp /boot/initrd.img-$KERN /$KERNDIR/
cp /boot/System.map-$KERN /$KERNDIR/
cp /boot/config-$KERN /$KERNDIR/
cp /$CONFDIR/cmdline.txt /$KERNDIR/
cat >> /$CONFDIR/config.txt << EOF

[all]
kernel=vmlinuz-$KERN
initramfs initrd.img-$KERN
os_prefix=$KERN/
overlay_prefix=o/$(if [[ "$KERN" =~ (v8|2712) ]]; then echo -e "\narm_64bit=1"; fi)
[all]
EOF
