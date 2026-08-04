#!/usr/bin/env bash
# Pass condition: /etc/fstab has a line mounting the partition's actual UUID
# at /mnt/labdata, `mount -a` succeeds cleanly, and /mnt/labdata is actually
# mounted from that partition right now.
set -uo pipefail

STASH="/var/tmp/rhelings/03_storage_partitions_05_persistent_mount_by_uuid.partition"

if [ ! -f "${STASH}" ]; then
    echo "No scratch partition recorded -- re-run setup (r)."
    exit 1
fi

PART="$(cat "${STASH}")"
if [ ! -b "${PART}" ]; then
    echo "${PART} is not a block device -- re-run setup (r) to recreate it."
    exit 1
fi

uuid="$(blkid -s UUID -o value "${PART}")"
if [ -z "${uuid}" ]; then
    echo "Could not read a UUID from ${PART} -- is it formatted?"
    exit 1
fi
echo "Partition UUID: ${uuid}"

fstab_line="$(grep -E "UUID=${uuid}[[:space:]]" /etc/fstab || true)"
if [ -z "${fstab_line}" ]; then
    echo "/etc/fstab has no UUID=${uuid} entry yet."
    grep -F "/mnt/labdata" /etc/fstab || echo "(no /mnt/labdata line in fstab at all)"
    exit 1
fi
echo "fstab entry: ${fstab_line}"

if ! echo "${fstab_line}" | awk '{print $2}' | grep -qx "/mnt/labdata"; then
    echo "The UUID=${uuid} entry doesn't mount at /mnt/labdata."
    exit 1
fi

mount_output="$(mount -a 2>&1)"
status=$?
if [ "${status}" -ne 0 ]; then
    echo "'mount -a' failed:"
    echo "${mount_output}"
    exit 1
fi

active="$(findmnt -n -o SOURCE /mnt/labdata 2>/dev/null || true)"
echo "Currently mounted from: ${active:-<not mounted>}"

if [ "${active}" != "${PART}" ]; then
    echo "/mnt/labdata is not currently mounted from ${PART}."
    exit 1
fi

exit 0
