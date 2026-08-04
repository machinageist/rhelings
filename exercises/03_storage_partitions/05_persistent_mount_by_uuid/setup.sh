#!/usr/bin/env bash
# Idempotent: fresh 512M loopback backing file, one GPT partition,
# pre-formatted as XFS (formatting isn't the point of this exercise).
# Unmounts /mnt/labdata if mounted and strips any /mnt/labdata line from
# /etc/fstab left over from a previous attempt, so the exercise always starts
# from "formatted partition exists, nothing mounted, fstab clean."
set -euo pipefail

BACKING_DIR="/var/tmp/rhelings-disks/03_storage_partitions"
BACKING_FILE="${BACKING_DIR}/05_persistent_mount_by_uuid.img"
STASH_DIR="/var/tmp/rhelings"
STASH="${STASH_DIR}/03_storage_partitions_05_persistent_mount_by_uuid.partition"

mkdir -p "${BACKING_DIR}" "${STASH_DIR}"

if mountpoint -q /mnt/labdata 2>/dev/null; then
    umount /mnt/labdata
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
mkfs.xfs -f -L LABDATA3 "${PART}" >/dev/null

echo "${PART}" > "${STASH}"

mkdir -p /mnt/labdata
sed -i '\#[[:space:]]/mnt/labdata[[:space:]]#d' /etc/fstab

echo "Scratch partition ready at ${PART}, formatted XFS, not yet mounted."
