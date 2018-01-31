chroot /tmp/temp /bin/bash  -c "ln -s /etc/yum.repos.d/NethServer.ns-epel /etc/yum.repos.d/epel.repo"

chroot /tmp/temp /bin/bash  -c "touch /var/spool/first-boot"
chroot /tmp/temp /bin/bash  -c "ln -s /usr/lib/systemd/system/nethserver-system-init.service /etc/systemd/system/multi-user.target.wants/nethserver-system-init.service"

