#!/usr/bin/env bash
# Pass condition: the stashed loop device has a GPT label and partition 1
# exists and is reasonably large (i.e. actually spans most of the disk, not a
# tiny leftover sliver).
set -uo pipefail

STASH="/var/tmp/rhelings/03_storage_partitions_02_parted_gpt_partition.loopdev"

if [ ! -f "${STASH}" ]; then
    echo "No scratch device recorded -- re-run setup (r)."
    exit 1
fi

LOOPDEV="$(cat "${STASH}")"
if [ ! -b "${LOOPDEV}" ]; then
    echo "${LOOPDEV} is not a block device -- re-run setup (r) to reattach it."
    exit 1
fi

label="$(parted -s "${LOOPDEV}" print 2>&1 | grep 'Partition Table' | awk '{print $3}')"
echo "Partition table: ${label:-<none>}"

if [ "${label}" != "gpt" ]; then
    echo "Expected a GPT partition table, found '${label:-none}'."
    exit 1
fi

partprobe "${LOOPDEV}" 2>/dev/null || true
PART="${LOOPDEV}p1"

if [ ! -b "${PART}" ]; then
    echo "${PART} does not exist. Did you create the partition after making the GPT label?"
    exit 1
fi

size_bytes="$(blockdev --getsize64 "${PART}")"
size_mib=$((size_bytes / 1024 / 1024))
echo "${PART} size: ${size_mib}MiB"

# Backing device is 1024MiB; require the partition to use most of it so a
# tiny throwaway partition doesn't pass.
if [ "${size_mib}" -ge 900 ]; then
    exit 0
fi

echo "Expected the partition to span most of the ~1024MiB disk, got ${size_mib}MiB."
exit 1
