#!/usr/bin/bash
DISKIMAGE=$1
STAGE1LOADER=$2
UBOOT=$3
ROOTPATH=$4
ROOTFILES=$5
ROOTPARTINDEX=$6
ROOTUUID=$7

#Enter Custom Commands Below
echo "Writing U-Boot Image"
dd if=$UBOOT of=$DISKIMAGE bs=1024 seek=8 conv=fsync,notrunc

# Removing RBF tmp repos
/bin/rm $ROOTPATH/etc/yum.repos.d/*_rbf.repo
echo "a7-ct" > $ROOTPATH/etc/yum/vars/infra
echo generic > $ROOTPATH/etc/yum/vars/kvariant

cat > $ROOTPATH/root/README << EOF
== CentOS 7 userland ==

If you want to automatically resize your / partition, just type the following (as root user):
/usr/local/bin/rootfs-expand

EOF


cat > $ROOTPATH/usr/local/bin/rootfs-expand << EOF
#!/bin/bash
clear
echo "Extending partition 3 to max size ...."
growpart /dev/mmcblk0 3
echo "Resizing ext4 filesystem ..."
resize2fs /dev/mmcblk0p3
echo "Done."
df -h |grep mmcblk0p3

EOF

chmod +x $ROOTPATH/usr/local/bin/rootfs-expand

exit 0
