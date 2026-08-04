#!/usr/bin/env bash
# Pass condition: the stashed partition's blkid reports TYPE="xfs" and
# LABEL="LABDATA1".
set -uo pipefail

STASH="/var/tmp/rhelings/03_storage_partitions_03_format_xfs.partition"

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
    echo "${PART} has no filesystem yet. Format it with mkfs.xfs."
    exit 1
fi

fstype="$(blkid -s TYPE -o value "${PART}")"
label="$(blkid -s LABEL -o value "${PART}")"

ok=1
if [ "${fstype}" != "xfs" ]; then
    echo "Expected TYPE=xfs, got '${fstype}'."
    ok=0
fi
if [ "${label}" != "LABDATA1" ]; then
    echo "Expected LABEL=LABDATA1, got '${label}'."
    ok=0
fi

[ "${ok}" -eq 1 ]
