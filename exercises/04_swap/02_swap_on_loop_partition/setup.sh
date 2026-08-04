#!/usr/bin/env bash
# Idempotent: fresh 512M loopback backing file, one GPT partition, left with
# no filesystem/swap signature. Strips any leftover fstab entry pointing at
# this partition's old UUID from a previous attempt (looked up before
# recreating the partition, since recreating it changes the UUID).
set -euo pipefail

BACKING_DIR="/var/tmp/rhelings-disks/04_swap"
BACKING_FILE="${BACKING_DIR}/02_swap_on_loop_partition.img"
STASH_DIR="/var/tmp/rhelings"
STASH="${STASH_DIR}/04_swap_02_swap_on_loop_partition.partition"

mkdir -p "${BACKING_DIR}" "${STASH_DIR}"

if [ -f "${STASH}" ]; then
    old_part="$(cat "${STASH}")"
    if [ -b "${old_part}" ]; then
        old_uuid="$(blkid -s UUID -o value "${old_part}" 2>/dev/null || true)"
        if [ -n "${old_uuid}" ]; then
            swapoff "${old_part}" 2>/dev/null || true
            sed -i "\#UUID=${old_uuid}#d" /etc/fstab
        fi
    fi
fi

if [ ! -f "${BACKING_FILE}" ]; then
    truncate -s 512M "${BACKING_FILE}"
fi

existing="$(losetup -j "${BACKING_FILE}" | cut -d: -f1)"
if [ -n "${existing}" ]; then
    losetup -d "${existing}" 2>/dev/null || true
fi

wipefs -a "${BACKING_FILE}" >/dev/null 2>&1 || true

LOOPDEV="$(losetup -f -P --show "${BACKING_FILE}")"

parted -s "${LOOPDEV}" mklabel gpt mkpart primary 1MiB 100%
partprobe "${LOOPDEV}" 2>/dev/null || true
sleep 1

PART="${LOOPDEV}p1"
wipefs -a "${PART}" >/dev/null 2>&1 || true

echo "${PART}" > "${STASH}"
echo "Scratch partition ready at ${PART}, no filesystem/swap signature."
