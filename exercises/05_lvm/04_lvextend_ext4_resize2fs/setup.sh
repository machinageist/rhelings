#!/usr/bin/env bash
# Idempotent: tears down vg_data04 if a previous attempt built/extended it,
# then rebuilds a fresh 1G PV/VG with a 300M ext4-formatted lv_ext401,
# mounted persistently at /mnt/ext4-grow.
set -euo pipefail

BACKING_DIR="/var/tmp/rhelings-disks/05_lvm"
BACKING_FILE="${BACKING_DIR}/04_lvextend_ext4_resize2fs.img"

mkdir -p "${BACKING_DIR}"

if mountpoint -q /mnt/ext4-grow 2>/dev/null; then
    umount /mnt/ext4-grow
fi
sed -i '\#[[:space:]]/mnt/ext4-grow[[:space:]]#d' /etc/fstab

vgremove -f vg_data04 >/dev/null 2>&1 || true

if [ ! -f "${BACKING_FILE}" ]; then
    truncate -s 1G "${BACKING_FILE}"
fi

existing="$(losetup -j "${BACKING_FILE}" | cut -d: -f1)"
if [ -n "${existing}" ]; then
    pvremove -ff -y "${existing}" >/dev/null 2>&1 || true
    losetup -d "${existing}" 2>/dev/null || true
fi

wipefs -a "${BACKING_FILE}" >/dev/null 2>&1 || true

LOOPDEV="$(losetup -f --show "${BACKING_FILE}")"
pvcreate -ff -y "${LOOPDEV}" >/dev/null
vgcreate vg_data04 "${LOOPDEV}" >/dev/null
lvcreate -n lv_ext401 -L 300M vg_data04 >/dev/null
mkfs.ext4 -q /dev/mapper/vg_data04-lv_ext401

mkdir -p /mnt/ext4-grow
echo "/dev/mapper/vg_data04-lv_ext401  /mnt/ext4-grow  ext4  defaults  0  0" >> /etc/fstab
mount /mnt/ext4-grow

echo "lv_ext401 ready: 300M, ext4, mounted at /mnt/ext4-grow. vg_data04 has free space to extend into."
