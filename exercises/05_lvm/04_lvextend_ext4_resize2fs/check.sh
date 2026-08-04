#!/usr/bin/env bash
# Pass condition: lv_ext401 is now at least 480M AND the mounted filesystem's
# visible size actually reflects that.
set -uo pipefail

if ! lvs vg_data04/lv_ext401 >/dev/null 2>&1; then
    echo "vg_data04/lv_ext401 does not exist -- re-run setup (r)."
    exit 1
fi

lv_mib="$(lvs --noheadings --units m -o lv_size --nosuffix vg_data04/lv_ext401 | tr -d ' ')"
lv_mib_int="${lv_mib%%.*}"
echo "lv_ext401 size: ${lv_mib}M"

if [ "${lv_mib_int}" -lt 480 ]; then
    echo "Expected lv_ext401 extended to roughly 500M (started at 300M), got ${lv_mib}M."
    exit 1
fi

if ! mountpoint -q /mnt/ext4-grow; then
    echo "/mnt/ext4-grow is not mounted."
    exit 1
fi

fs_kb="$(df --output=size -k /mnt/ext4-grow | tail -1 | tr -d ' ')"
fs_mib=$((fs_kb / 1024))
echo "Filesystem visible size at /mnt/ext4-grow: ${fs_mib}M"

if [ "${fs_mib}" -lt 430 ]; then
    echo "The LV grew but the filesystem still reports roughly its old size."
    echo "lvextend resizes the block device -- it doesn't grow the filesystem on top of it."
    echo "Run resize2fs against the device (not xfs_growfs -- this is ext4)."
    exit 1
fi

exit 0
