#!/usr/bin/env bash
# Idempotent: tears down vg_data02 and its LV if a previous attempt built
# them, unmounts /mnt/app-data and cleans its fstab entry, then rebuilds a
# fresh 1G PV/VG with no logical volumes yet -- the exercise's starting
# state.
set -euo pipefail

BACKING_DIR="/var/tmp/rhelings-disks/05_lvm"
STASH_DIR="/var/tmp/rhelings"
BACKING_FILE="${BACKING_DIR}/02_lvcreate_and_mount.img"

mkdir -p "${BACKING_DIR}" "${STASH_DIR}"

if mountpoint -q /mnt/app-data 2>/dev/null; then
    umount /mnt/app-data
fi
sed -i '\#[[:space:]]/mnt/app-data[[:space:]]#d' /etc/fstab

vgremove -f vg_data02 >/dev/null 2>&1 || true

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
vgcreate vg_data02 "${LOOPDEV}" >/dev/null

mkdir -p /mnt/app-data

echo "vg_data02 ready on ${LOOPDEV}, no logical volumes yet."
