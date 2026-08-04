#!/usr/bin/env bash
# Idempotent: tears down vg_data06 if a previous attempt touched it, then
# rebuilds a fresh 500M PV/VG with lv_grow taking up 400M of it (formatted
# XFS, mounted), and a second, separate 500M loop device left completely
# unattached to any VG -- the free PV this exercise asks you to add.
set -euo pipefail

BACKING_DIR="/var/tmp/rhelings-disks/05_lvm"
STASH_DIR="/var/tmp/rhelings"
BACKING_FILE_1="${BACKING_DIR}/06_vgextend_new_pv_main.img"
BACKING_FILE_2="${BACKING_DIR}/06_vgextend_new_pv_new.img"
STASH="${STASH_DIR}/05_lvm_06_vgextend_new_pv.newdev"

mkdir -p "${BACKING_DIR}" "${STASH_DIR}"

if mountpoint -q /mnt/xfs-vgextend 2>/dev/null; then
    umount /mnt/xfs-vgextend
fi
sed -i '\#[[:space:]]/mnt/xfs-vgextend[[:space:]]#d' /etc/fstab

vgremove -f vg_data06 >/dev/null 2>&1 || true

for BACKING_FILE in "${BACKING_FILE_1}" "${BACKING_FILE_2}"; do
    if [ ! -f "${BACKING_FILE}" ]; then
        truncate -s 500M "${BACKING_FILE}"
    fi
    existing="$(losetup -j "${BACKING_FILE}" | cut -d: -f1)"
    if [ -n "${existing}" ]; then
        pvremove -ff -y "${existing}" >/dev/null 2>&1 || true
        losetup -d "${existing}" 2>/dev/null || true
    fi
    wipefs -a "${BACKING_FILE}" >/dev/null 2>&1 || true
done

LOOPDEV_MAIN="$(losetup -f --show "${BACKING_FILE_1}")"
LOOPDEV_NEW="$(losetup -f --show "${BACKING_FILE_2}")"

pvcreate -ff -y "${LOOPDEV_MAIN}" >/dev/null
vgcreate vg_data06 "${LOOPDEV_MAIN}" >/dev/null
lvcreate -n lv_grow -L 400M vg_data06 >/dev/null
mkfs.xfs /dev/mapper/vg_data06-lv_grow >/dev/null

mkdir -p /mnt/xfs-vgextend
echo "/dev/mapper/vg_data06-lv_grow  /mnt/xfs-vgextend  xfs  defaults  0  0" >> /etc/fstab
mount /mnt/xfs-vgextend

echo "${LOOPDEV_NEW}" > "${STASH}"

echo "vg_data06 has one nearly-full PV. New unattached PV candidate: ${LOOPDEV_NEW}"
