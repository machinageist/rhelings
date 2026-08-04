#!/usr/bin/env bash
# Idempotent: tears down vg_data05 if a previous attempt touched it, then
# rebuilds a fresh 1G PV/VG with lv_gotcha created at 300M, formatted XFS,
# mounted at /mnt/xfs-gotcha -- then, deliberately, ALREADY extends the LV to
# 500M at the block-device layer via lvextend, without ever growing the
# filesystem. That gap (LV bigger, filesystem still reporting the old size)
# is the bug this exercise asks you to diagnose and fix.
set -euo pipefail

BACKING_DIR="/var/tmp/rhelings-disks/05_lvm"
BACKING_FILE="${BACKING_DIR}/05_diagnose_forgot_to_grow_fs.img"

mkdir -p "${BACKING_DIR}"

if mountpoint -q /mnt/xfs-gotcha 2>/dev/null; then
    umount /mnt/xfs-gotcha
fi
sed -i '\#[[:space:]]/mnt/xfs-gotcha[[:space:]]#d' /etc/fstab

vgremove -f vg_data05 >/dev/null 2>&1 || true

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
vgcreate vg_data05 "${LOOPDEV}" >/dev/null
lvcreate -n lv_gotcha -L 300M vg_data05 >/dev/null
mkfs.xfs /dev/mapper/vg_data05-lv_gotcha >/dev/null

mkdir -p /mnt/xfs-gotcha
echo "/dev/mapper/vg_data05-lv_gotcha  /mnt/xfs-gotcha  xfs  defaults  0  0" >> /etc/fstab
mount /mnt/xfs-gotcha

# The bug: extend the LV, but never grow the filesystem on top of it.
lvextend -L +200M /dev/mapper/vg_data05-lv_gotcha >/dev/null

echo "lv_gotcha is now ~500M at the LVM layer, but /mnt/xfs-gotcha still reports ~300M."
