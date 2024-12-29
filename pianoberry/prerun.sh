#!/bin/bash -e

if [ ! -d "${ROOTFS_DIR}" ]; then
    copy_previous
fi

# Clean apt cache (to mitigate disk space issues)
rm -rf "${ROOTFS_DIR}/var/cache/apt/archives/*"
