#!/usr/bin/bash
DISKIMAGE=$1
STAGE1LOADER=$2
UBOOT=$3
ROOTPATH=$4
ROOTFILES=$5
ROOTPARTINDEX=$6
ROOTUUID=$7

#Enter Custom Commands Below
#echo "Extracting Boot Files"
#tar Jxvomf $ROOTFILES -C $ROOTPATH
#sed -i 's/mmcblk0p3/mmcblk0p'$ROOTPARTINDEX'/' $ROOTPATH/boot/cmdline.txt
echo "Creating boot config files for rpi2 .."
cat > $ROOTPATH/boot/cmdline.txt << EOF
dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p3 rootfstype=ext4 elevator=deadline rootwait
EOF
cat > $ROOTPATH/boot/config.txt << EOF
#The Pi2 Model B default clock frequency 900MHz
arm_freq=900
# NOOBS Auto-generated Settings:
hdmi_force_hotplug=1
config_hdmi_boost=4
overscan_left=24
overscan_right=24
overscan_top=16
overscan_bottom=16
disable_overscan=0
core_freq=250
sdram_freq=400
over_voltage=0
EOF

sed -i 's/IPv6_rpfilter=yes/IPv6_rpfilter=no/' $ROOTPATH/etc/firewalld/firewalld.conf

# Removing RBF tmp repos
/bin/rm $ROOTPATH/etc/yum.repos.d/*_rbf.repo
echo "a7-ct" > $ROOTPATH/etc/yum/vars/infra
echo "rpi2" > $ROOTPATH/etc/yum/vars/kvariant

cat > $ROOTPATH/root/README << EOF
== CentOS 7 userland ==

If you want to automatically resize your / partition, just type the following (as root user):
/usr/bin/rootfs-expand

EOF

exit 0
