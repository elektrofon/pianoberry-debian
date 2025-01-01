#!/bin/bash -e

install -m 755 files/linux-image-6.6.50-rt42-v8-16k+_6.6.50-1_arm64.deb "${ROOTFS_DIR}/root/"
install -m 755 files/install_kernel.sh "${ROOTFS_DIR}/boot/"

on_chroot << EOF
chmod +x /boot/install_kernel.sh
EOF

# Create first boot service
################################################################
on_chroot << EOF
cat <<EOC > "/etc/systemd/system/firstboot.service"
[Unit]
Description=FirstBoot
Before=getty.target rc-local.service
Requires=local-fs.target
After=local-fs.target
ConditionPathExists=!/var/log/firstboot-done
DefaultDependencies=no

[Service]
ExecStart=/boot/install_kernel.sh
ExecStopPost=touch /var/log/firstboot-done
ExecStopPost=/sbin/reboot -f
Type=oneshot
RemainAfterExit=no

[Install]
WantedBy=sysinit.target
EOC
EOF


# Enable firstboot service
################################################################
on_chroot << EOF
SUDO_USER="${FIRST_USER_NAME}" systemctl enable firstboot
EOF
