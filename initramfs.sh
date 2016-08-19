echo [INFO ]  $0 Creating                 Initramfs
if [ -f /tmp/temp/boot/initramfs-4.4.14-v7.img ]; then echo  [INFO ]  $0 Initramfs Exists; else chroot /tmp/temp dracut /boot/initramfs-4.4.14-v7.img 4.4.14-v7; fi 2>> rbf.log
echo [INFO ]  $0 Creating                 Initramfs
if [ -f /tmp/temp/boot/initramfs-4.4.14-v7.2.20160704gite98827a.el7.img ]; then echo  [INFO ]  $0 Initramfs Exists; else chroot /tmp/temp dracut /boot/initramfs-4.4.14-v7.2.20160704gite98827a.el7.img 4.4.14-v7.2.20160704gite98827a.el7; fi 2>> rbf.log
