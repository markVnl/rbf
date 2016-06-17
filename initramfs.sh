echo [INFO ]  $0 Creating                 Initramfs
if [ -f /tmp/temp/boot/initramfs-4.4.12-301.el7.armv7hl.img ]; then echo  [INFO ]  $0 Initramfs Exists; else chroot /tmp/temp dracut /boot/initramfs-4.4.12-301.el7.armv7hl.img 4.4.12-301.el7.armv7hl; fi 2>> rbf.log
mkdir /tmp/temp/boot/extlinux
if [ $? != 0 ]; then exit 217; fi

cat > /tmp/temp/boot/extlinux/extlinux.conf << EOF
#Created by RootFS Build Factory
ui menu.c32
menu autoboot centos
menu title centos Options
#menu hidden
timeout 60
totaltimeout 600
label centos
	kernel /vmlinuz-4.4.12-301.el7.armv7hl
	append enforcing=0 root=UUID=9a8688e4-2d43-4584-a91e-76bae8440b5c
	fdtdir /dtb-4.4.12-301.el7.armv7hl
	initrd /initramfs-4.4.12-301.el7.armv7hl.img

EOF
if [ $? != 0 ]; then exit 217; fi

