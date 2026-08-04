#!/usr/bin/env bash
# Pass condition: lv_xfs01 is now at least 480M (extended from the original
# 300M) AND the mounted filesystem's visible size actually reflects that --
# not just the LV layer, which is the whole point of this exercise.
set -uo pipefail

if ! lvs vg_data03/lv_xfs01 >/dev/null 2>&1; then
    echo "vg_data03/lv_xfs01 does not exist -- re-run setup (r)."
    exit 1
fi

lv_mib="$(lvs --noheadings --units m -o lv_size --nosuffix vg_data03/lv_xfs01 | tr -d ' ')"
lv_mib_int="${lv_mib%%.*}"
echo "lv_xfs01 size: ${lv_mib}M"

if [ "${lv_mib_int}" -lt 480 ]; then
    echo "Expected lv_xfs01 extended to roughly 500M (started at 300M), got ${lv_mib}M."
    exit 1
fi

if ! mountpoint -q /mnt/xfs-grow; then
    echo "/mnt/xfs-grow is not mounted."
    exit 1
fi

fs_kb="$(df --output=size -k /mnt/xfs-grow | tail -1 | tr -d ' ')"
fs_mib=$((fs_kb / 1024))
echo "Filesystem visible size at /mnt/xfs-grow: ${fs_mib}M"

if [ "${fs_mib}" -lt 450 ]; then
    echo "The LV grew but the filesystem still reports roughly its old size."
    echo "lvextend resizes the block device -- it doesn't grow the filesystem on top of it."
    echo "Run xfs_growfs against the mount point too."
    exit 1
fi

exit 0
