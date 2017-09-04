umount /tmp/temp/boot
umount /tmp/temp/proc
umount -l /tmp/temp/dev/
sleep 2
umount /tmp/temp
[ -b /dev/loop3 ] && losetup -d /dev/loop3 &>> rbf.log
exit 0
