#!/bin/bash -e

# Add user to groups
################################################################
on_chroot <<EOF
for GRP in input spi i2c gpio; do
	groupadd -f -r "\$GRP"
done
for GRP in adm dialout cdrom audio users sudo video games plugdev input gpio spi i2c render; do
	adduser $FIRST_USER_NAME \$GRP
done
EOF


# Set up directories and install files
################################################################
mkdir -p "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/Modartt"
mkdir -p "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.local/share/Modartt/Pianoteq/MidiMappings"

install -m 755 "files/Pianoteq 8" "${ROOTFS_DIR}/usr/local/bin/"
install -m 755 files/Pianoteq84.prefs "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config/Modartt/"
install -m 755 files/midi-map.ptm "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.local/share/Modartt/Pianoteq/MidiMappings/"

chown -R 1000:1000 "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.config"
chown -R 1000:1000 "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.local"


# Enable quiet boot for faster boot times
################################################################
on_chroot << EOF
SUDO_USER="${FIRST_USER_NAME}" sed -i '$ s/$/ quiet/' /boot/firmware/cmdline.txt
EOF


# Disable bluetooth
################################################################
on_chroot << EOF
SUDO_USER="${FIRST_USER_NAME}" echo 'dtoverlay=disable-bt' >> /boot/firmware/config.txt
SUDO_USER="${FIRST_USER_NAME}" echo 'dtoverlay=miniuart-bt' >> /boot/firmware/config.txt
SUDO_USER="${FIRST_USER_NAME}" systemctl disable hciuart
SUDO_USER="${FIRST_USER_NAME}" systemctl disable bluetooth
SUDO_USER="${FIRST_USER_NAME}" systemctl stop hciuart
SUDO_USER="${FIRST_USER_NAME}" systemctl stop bluetooth
EOF


# Set audio limits
################################################################
on_chroot << EOF
cat <<EOC > "/etc/security/limits.d/30-audio-rlimits.conf"
@audio - rtprio 95
@audio - nice -10
@audio - memlock unlimited
EOC
EOF


# Create Pianoteq service
################################################################
on_chroot << EOF
cat <<EOC > "/etc/systemd/system/pianoteq.service"
[Unit]
Description=Pianoteq Service

[Service]
LimitRTPRIO=95
LimitMEMLOCK=infinity
ExecStart="/usr/local/bin/Pianoteq 8" --multicore max --headless --preset "U4 Felt II" --midimapping "midi-map"
Restart=on-failure
RestartSec=5
User=${FIRST_USER_NAME}
Group=audio

[Install]
WantedBy=multi-user.target
EOC
EOF


# Enable services
################################################################
on_chroot << EOF
SUDO_USER="${FIRST_USER_NAME}" systemctl enable pianoteq
EOF


# Cleanup
################################################################
# on_chroot << EOF
# SUDO_USER="${FIRST_USER_NAME}" apt autoremove -y
# SUDO_USER="${FIRST_USER_NAME}" apt-get clean
# SUDO_USER="${FIRST_USER_NAME}" rm -rf /var/lib/apt/lists/*
# SUDO_USER="${FIRST_USER_NAME}" rm -rf /root/.cache
# SUDO_USER="${FIRST_USER_NAME}" rm -rf /root/.cargo
# EOF
