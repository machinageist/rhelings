#!/usr/bin/env bash
# Idempotent: tears down vg_data01 if a previous attempt created it, then
# (re)creates two independent 1G sparse-file-backed loop devices, wiped of
# any LVM/filesystem signature, ready to be turned into PVs.
set -euo pipefail

BACKING_DIR="/var/tmp/rhelings-disks/05_lvm"
STASH_DIR="/var/tmp/rhelings"
STASH="${STASH_DIR}/05_lvm_01_pvcreate_vgcreate.loopdevs"

mkdir -p "${BACKING_DIR}" "${STASH_DIR}"

vgremove -f vg_data01 >/dev/null 2>&1 || true

> "${STASH}"
for n in 1 2; do
    BACKING_FILE="${BACKING_DIR}/01_pvcreate_vgcreate_${n}.img"

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
    echo "${LOOPDEV}" >> "${STASH}"
done

echo "Scratch devices ready:"
cat "${STASH}"
