#!/usr/bin/env bash
# Idempotent: creates (or reuses) a 512M sparse backing file, always detaches
# and re-attaches it as a fresh loop device, wipes any old partition table
# and filesystem signature, then creates one GPT partition spanning the
# device -- left unformatted, which is the exercise's starting state.
set -euo pipefail

BACKING_DIR="/var/tmp/rhelings-disks/03_storage_partitions"
BACKING_FILE="${BACKING_DIR}/03_format_xfs.img"
STASH_DIR="/var/tmp/rhelings"
STASH="${STASH_DIR}/03_storage_partitions_03_format_xfs.partition"

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
