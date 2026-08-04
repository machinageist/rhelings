#!/usr/bin/env bash
# Pass condition: partition 1 exists on the stashed loop device and its size
# is within a tolerance band around 500MiB (fdisk's "+500M" sizing can land a
# few MiB off due to alignment, so this isn't an exact-byte comparison).
set -uo pipefail

STASH="/var/tmp/rhelings/03_storage_partitions_01_fdisk_new_partition.loopdev"

if [ ! -f "${STASH}" ]; then
    echo "No scratch device recorded -- re-run setup (r)."
    exit 1
fi

LOOPDEV="$(cat "${STASH}")"
if [ ! -b "${LOOPDEV}" ]; then
    echo "${LOOPDEV} is not a block device -- re-run setup (r) to reattach it."
    exit 1
fi

partprobe "${LOOPDEV}" 2>/dev/null || true
PART="${LOOPDEV}p1"

if [ ! -b "${PART}" ]; then
    echo "${PART} does not exist yet. Did you write the partition table with 'w' in fdisk?"
    exit 1
fi

size_bytes="$(blockdev --getsize64 "${PART}")"
size_mib=$((size_bytes / 1024 / 1024))
echo "${PART} size: ${size_mib}MiB"

MIN_MIB=400
MAX_MIB=600

if [ "${size_mib}" -ge "${MIN_MIB}" ] && [ "${size_mib}" -le "${MAX_MIB}" ]; then
    exit 0
fi

echo "Expected roughly 500MiB (allowed range ${MIN_MIB}-${MAX_MIB}MiB), got ${size_mib}MiB."
exit 1
