#!/usr/bin/env bash
# Pass condition: lv_app exists in vg_data02 sized ~300MB, formatted XFS,
# mounted at /mnt/app-data right now, and persistently in /etc/fstab via its
# /dev/mapper path.
set -uo pipefail

if ! vgs vg_data02 >/dev/null 2>&1; then
    echo "vg_data02 does not exist -- re-run setup (r)."
    exit 1
fi

if ! lvs vg_data02/lv_app >/dev/null 2>&1; then
    echo "Logical volume lv_app does not exist in vg_data02 yet."
    exit 1
fi

MAPPER_PATH="/dev/mapper/vg_data02-lv_app"
size_mib="$(lvs --noheadings --units m -o lv_size --nosuffix vg_data02/lv_app | tr -d ' ')"
size_mib_int="${size_mib%%.*}"
echo "lv_app size: ${size_mib}M"

ok=1
if [ "${size_mib_int}" -lt 280 ] || [ "${size_mib_int}" -gt 320 ]; then
    echo "Expected lv_app around 300M, got ${size_mib}M."
    ok=0
fi

fstype="$(blkid -s TYPE -o value "${MAPPER_PATH}" 2>/dev/null || true)"
echo "Filesystem type: ${fstype:-<none>}"
if [ "${fstype}" != "xfs" ]; then
    echo "Expected lv_app formatted as XFS."
    ok=0
fi

if ! grep -qE "^${MAPPER_PATH//\//\\/}[[:space:]]" /etc/fstab; then
    echo "/etc/fstab has no entry using ${MAPPER_PATH}."
    ok=0
fi

active="$(findmnt -n -o SOURCE /mnt/app-data 2>/dev/null || true)"
echo "Currently mounted from: ${active:-<not mounted>}"
if [ "${active}" != "${MAPPER_PATH}" ]; then
    echo "/mnt/app-data is not currently mounted from ${MAPPER_PATH}."
    ok=0
fi

[ "${ok}" -eq 1 ]
