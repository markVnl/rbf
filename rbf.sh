echo [INFO ]   $0 Detaching Loopback Device: /dev/loop2
[ -b /dev/loop2 ] && losetup -d /dev/loop2 &>> rbf.log
echo [INFO ]    $0 Creating CentOS-7-core-cubietruck.img
dd if=/dev/zero of="CentOS-7-core-cubietruck.img" bs=1M count=0 seek=3072 &>> rbf.log 
if [ $? != 0 ]; then exit 200; fi

losetup /dev/loop2 "CentOS-7-core-cubietruck.img" &>> rbf.log
if [ $? != 0 ]; then exit 220; fi

echo [INFO ]   $0 Creating Parititons
parted /dev/loop2 --align optimal -s mklabel msdos mkpart primary ext3 2048s 616447s mkpart primary linux-swap 616448s 1665023s mkpart primary ext4 1665024s 5859327s  &>> rbf.log 
if [ $? != 0 ]; then exit 201; fi

partprobe /dev/loop2 &>> rbf.log
if [ $? != 0 ]; then exit 221; fi

[ -b /dev/loop2p1 ] && echo [INFO ]   $0 Creating Filesystem ext3 on partition 1 || exit 203
mkfs.ext3 -U fd20a174-8639-40ea-a697-4b2e4a88f864 /dev/loop2p1 &>> rbf.log 
[ -b /dev/loop2p2 ] && echo [INFO ]   $0 Creating Filesystem swap on partition 2 || exit 203
mkswap -U 1ba18ba2-43ab-4d18-84e2-5d1659430ae8 /dev/loop2p2 &>> rbf.log 
[ -b /dev/loop2p3 ] && echo [INFO ]   $0 Creating Filesystem ext4 on partition 3 || exit 203
mkfs.ext4 -U 0a296c36-f629-4899-a8c4-809d59a8330e /dev/loop2p3 &>> rbf.log 
mkdir -p /tmp/temp
if [ $? != 0 ]; then exit 222; fi

echo [INFO ]   $0 Mouting Parititon 3 on /
mount /dev/loop2p3 /tmp/temp/
if [ $? != 0 ]; then exit 204; fi

mkdir -p /tmp/temp//boot
echo [INFO ]   $0 Mouting Parititon 1 on /boot
mount /dev/loop2p1 /tmp/temp/boot
if [ $? != 0 ]; then exit 204; fi

mkdir /tmp/temp/proc /tmp/temp/sys /tmp/temp/dev
mount -t proc proc /tmp/temp/proc
mount --bind /dev /tmp/temp/dev
rm -rf /tmp/temp/etc/yum.repos.d
mkdir -p /tmp/temp/etc/yum.repos.d
cat > /tmp/temp/etc/yum.repos.d/centos-base_rbf.repo << EOF
[centos-base_rbf]
name=centos-base_rbf
baseurl=http://armv7.dev.centos.org/repos/7/tosign/os/armhfp/
gpgcheck=0
enabled=1
EOF
if [ $? != 0 ]; then exit 205; fi

cat > /tmp/temp/etc/yum.repos.d/centos-extras_rbf.repo << EOF
[centos-extras_rbf]
name=centos-extras_rbf
baseurl=http://armv7.dev.centos.org/repos/7/extras/armhfp/
gpgcheck=0
enabled=1
EOF
if [ $? != 0 ]; then exit 205; fi

cat > /tmp/temp/etc/yum.repos.d/centos-arm-kernels_rbf.repo << EOF
[centos-arm-kernels_rbf]
name=centos-arm-kernels_rbf
baseurl=http://armv7.dev.centos.org/repos/7/kernel/armhfp/kernel-4.2.3/
gpgcheck=0
enabled=1
EOF
if [ $? != 0 ]; then exit 205; fi

rpm --root /tmp/temp --initdb
if [ $? != 0 ]; then exit 208; fi

echo [INFO ]  $0 Installing Package Groups. Please Wait
yum --disablerepo=* --enablerepo=centos-base_rbf --enablerepo=centos-extras_rbf --enablerepo=centos-arm-kernels_rbf  --installroot=/tmp/temp --releasever=7 groupinstall -y core 2>> rbf.log
if [ $? != 0 ]; then echo [INFO ]  GROUP_INSTALL_ERROR: Error Installing Some Package Groups; read -p "Press Enter To Continue"; fi

echo [INFO ]  $0 Installing Packages. Please Wait
yum --disablerepo=* --enablerepo=centos-base_rbf --enablerepo=centos-extras_rbf --enablerepo=centos-arm-kernels_rbf  --installroot=/tmp/temp --releasever=7 install -y rootfs-resize net-tools 2>> rbf.log
if [ $? != 0 ]; then echo [INFO ]  PACKAGE_INSTALL_ERROR: Error Installing Some Packages; read -p "Press Enter To Continue"; fi

echo [INFO ]  $0 Installing Kernel Packages. Please Wait
yum --disablerepo=* --enablerepo=centos-base_rbf --enablerepo=centos-extras_rbf --enablerepo=centos-arm-kernels_rbf  --installroot=/tmp/temp --releasever=7 install -y kernel dracut-config-generic 2>> rbf.log
if [ $? != 0 ]; then echo [INFO ]  KERNEL_PACKAGE_INSTALL_ERROR: Error installing Kernel Packages; read -p "Press Enter To Continue"; fi

cp kernelup.d/rbfcubietruck.sh /tmp/temp/usr/sbin/
if [ $? != 0 ]; then echo [INFO ]  KERNELUP_ERROR: Could not copy kernel upgrade script; read -p "Press Enter To Continue"; fi

cp -rpv ./etc/* /tmp/temp/etc/ &>> rbf.log 
if [ $? != 0 ]; then exit 211; fi

echo "root:centos" | chpasswd --root /tmp/temp &>> rbf.log
if [ $? != 0 ]; then echo [INFO ]  ROOT_PASS_ERROR: Could Not Set Root Pass; read -p "Press Enter To Continue"; fi

sed -i 's/SELINUX=enforcing/SELINUX=permissive/' /tmp/temp/etc/selinux/config  &>> rbf.log 
if [ $? != 0 ]; then echo [INFO ]  SELINUX_ERROR: Could Not Set SELINUX Status; read -p "Press Enter To Continue"; fi

exit 0
