echo [INFO ]  $0 Creating                 Initramfs
if [ -f /tmp/temp/boot/initramfs-4.4.34-201.el7.armv7hl.img ]; then echo  [INFO ]  $0 Initramfs Exists; else chroot /tmp/temp dracut /boot/initramfs-4.4.34-201.el7.armv7hl.img 4.4.34-201.el7.armv7hl; fi 2>> rbf.log
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
	kernel /vmlinuz-4.4.34-201.el7.armv7hl
	append enforcing=0 root=UUID=4c29f94e-c2db-4436-a443-744aac063574
	fdtdir /dtb-4.4.34-201.el7.armv7hl
	initrd /initramfs-4.4.34-201.el7.armv7hl.img

EOF
if [ $? != 0 ]; then exit 217; fi

