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
dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p3 rootfstype=ext4 elevator=deadline rootwait selinux=1 security=selinux enforcing=0
EOF
cat > $ROOTPATH/boot/config.txt << EOF
#The Pi3 Model B default clock frequency 1200MHz.
arm_freq=1200
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


cat > $ROOTPATH/usr/lib/firmware/brcm/brcmfmac43430-sdio.txt << EOF
# NVRAM file for BCM943430WLPTH
# 2.4 GHz, 20 MHz BW mode

# The following parameter values are just placeholders, need to be updated.
manfid=0x2d0
prodid=0x0727
vendid=0x14e4
devid=0x43e2
boardtype=0x0727
boardrev=0x1101
boardnum=22
#macaddr=00:90:4c:c5:12:38
sromrev=11
boardflags=0x00404201
boardflags3=0x08000000
xtalfreq=37400
nocrc=1
ag0=255
aa2g=1
ccode=ALL

pa0itssit=0x20
extpagain2g=0
#PA parameters for 2.4GHz, measured at CHIP OUTPUT
pa2ga0=-168,7161,-820
AvVmid_c0=0x0,0xc8
cckpwroffset0=5

# PPR params
maxp2ga0=84
txpwrbckof=6
cckbw202gpo=0
legofdmbw202gpo=0x66111111
mcsbw202gpo=0x77711111
propbw202gpo=0xdd

# OFDM IIR :
ofdmdigfilttype=18
ofdmdigfilttypebe=18
# PAPD mode:
papdmode=1
papdvalidtest=1
pacalidx2g=42
papdepsoffset=-22
papdendidx=58

# LTECX flags
ltecxmux=0
ltecxpadnum=0x0102
ltecxfnsel=0x44
ltecxgcigpio=0x01

il0macaddr=00:90:4c:c5:12:38
wl0id=0x431b

deadman_to=0xffffffff
# muxenab: 0x1 for UART enable, 0x2 for GPIOs, 0x8 for JTAG
muxenab=0x1
# CLDO PWM voltage settings - 0x4 - 1.1 volt
#cldo_pwm=0x4

#VCO freq 326.4MHz
spurconfig=0x3 

edonthd20l=-75
edoffthd20ul=-80

EOF

exit 0



