#!/usr/bin/env bash
# Idempotent: creates (or reuses) a 1G sparse backing file, always detaches
# and re-attaches it as a fresh loop device with partition scanning enabled
# (-P), and wipes any existing partition table -- so every run of this script
# starts from "attached, blank block device," regardless of what a previous
# attempt did to it.
set -euo pipefail

BACKING_DIR="/var/tmp/rhelings-disks/03_storage_partitions"
BACKING_FILE="${BACKING_DIR}/01_fdisk_new_partition.img"
STASH_DIR="/var/tmp/rhelings"
STASH="${STASH_DIR}/03_storage_partitions_01_fdisk_new_partition.loopdev"

mkdir -p "${BACKING_DIR}" "${STASH_DIR}"

if [ ! -f "${BACKING_FILE}" ]; then
    truncate -s 1G "${BACKING_FILE}"
fi

existing="$(losetup -j "${BACKING_FILE}" | cut -d: -f1)"
if [ -n "${existing}" ]; then
    losetup -d "${existing}" 2>/dev/null || true
fi

wipefs -a "${BACKING_FILE}" >/dev/null 2>&1 || true

LOOPDEV="$(losetup -f -P --show "${BACKING_FILE}")"
echo "${LOOPDEV}" > "${STASH}"

echo "Scratch device ready at ${LOOPDEV} (backed by ${BACKING_FILE})."
