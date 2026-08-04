#!/usr/bin/env bash
# Idempotent: same pattern as the XFS formatting exercise -- fresh 512M
# loopback backing file, one GPT partition, left unformatted.
set -euo pipefail

BACKING_DIR="/var/tmp/rhelings-disks/03_storage_partitions"
BACKING_FILE="${BACKING_DIR}/04_format_ext4.img"
STASH_DIR="/var/tmp/rhelings"
STASH="${STASH_DIR}/03_storage_partitions_04_format_ext4.partition"

mkdir -p "${BACKING_DIR}" "${STASH_DIR}"

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
echo "Scratch partition ready at ${PART}, unformatted."
