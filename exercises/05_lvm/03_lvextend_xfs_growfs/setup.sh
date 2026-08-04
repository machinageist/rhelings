#!/usr/bin/env bash
# Idempotent: tears down vg_data03 if a previous attempt built/extended it,
# then rebuilds a fresh 1G PV/VG with a 300M XFS-formatted lv_xfs01, mounted
# persistently at /mnt/xfs-grow -- the "not yet extended" starting state.
set -euo pipefail

BACKING_DIR="/var/tmp/rhelings-disks/05_lvm"
BACKING_FILE="${BACKING_DIR}/03_lvextend_xfs_growfs.img"

mkdir -p "${BACKING_DIR}"

if mountpoint -q /mnt/xfs-grow 2>/dev/null; then
    umount /mnt/xfs-grow
fi
sed -i '\#[[:space:]]/mnt/xfs-grow[[:space:]]#d' /etc/fstab

vgremove -f vg_data03 >/dev/null 2>&1 || true

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
vgcreate vg_data03 "${LOOPDEV}" >/dev/null
lvcreate -n lv_xfs01 -L 300M vg_data03 >/dev/null
mkfs.xfs /dev/mapper/vg_data03-lv_xfs01 >/dev/null

mkdir -p /mnt/xfs-grow
echo "/dev/mapper/vg_data03-lv_xfs01  /mnt/xfs-grow  xfs  defaults  0  0" >> /etc/fstab
mount /mnt/xfs-grow

echo "lv_xfs01 ready: 300M, XFS, mounted at /mnt/xfs-grow. vg_data03 has free space to extend into."
