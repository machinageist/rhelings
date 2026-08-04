#!/usr/bin/env bash
# Pass condition: the stashed partition's blkid reports TYPE="ext4" and
# LABEL="LABDATA2".
set -uo pipefail

STASH="/var/tmp/rhelings/03_storage_partitions_04_format_ext4.partition"

if [ ! -f "${STASH}" ]; then
    echo "No scratch partition recorded -- re-run setup (r)."
    exit 1
fi

PART="$(cat "${STASH}")"
if [ ! -b "${PART}" ]; then
    echo "${PART} is not a block device -- re-run setup (r) to recreate it."
    exit 1
fi

info="$(blkid "${PART}" 2>&1)"
echo "${info}"

if [ -z "${info}" ]; then
    echo "${PART} has no filesystem yet. Format it with mkfs.ext4."
    exit 1
fi

fstype="$(blkid -s TYPE -o value "${PART}")"
label="$(blkid -s LABEL -o value "${PART}")"

ok=1
if [ "${fstype}" != "ext4" ]; then
    echo "Expected TYPE=ext4, got '${fstype}'."
    ok=0
fi
if [ "${label}" != "LABDATA2" ]; then
    echo "Expected LABEL=LABDATA2, got '${label}'."
    ok=0
fi

[ "${ok}" -eq 1 ]
