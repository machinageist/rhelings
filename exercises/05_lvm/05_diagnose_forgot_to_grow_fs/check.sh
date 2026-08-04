#!/usr/bin/env bash
# Pass condition: lv_gotcha is still ~500M (unchanged -- re-running lvextend
# isn't the fix and isn't necessary) AND the filesystem now also reports
# ~500M, proving the missing growfs step was performed.
set -uo pipefail

if ! lvs vg_data05/lv_gotcha >/dev/null 2>&1; then
    echo "vg_data05/lv_gotcha does not exist -- re-run setup (r)."
    exit 1
fi

lv_mib="$(lvs --noheadings --units m -o lv_size --nosuffix vg_data05/lv_gotcha | tr -d ' ')"
lv_mib_int="${lv_mib%%.*}"
echo "lv_gotcha size: ${lv_mib}M"

if [ "${lv_mib_int}" -lt 480 ]; then
    echo "lv_gotcha is smaller than expected -- it should already be ~500M from setup."
    exit 1
fi

if ! mountpoint -q /mnt/xfs-gotcha; then
    echo "/mnt/xfs-gotcha is not mounted."
    exit 1
fi

fs_kb="$(df --output=size -k /mnt/xfs-gotcha | tail -1 | tr -d ' ')"
fs_mib=$((fs_kb / 1024))
echo "Filesystem visible size at /mnt/xfs-gotcha: ${fs_mib}M"

if [ "${fs_mib}" -lt 450 ]; then
    echo "The LV is already the right size, but the filesystem hasn't been grown to match."
    echo "This is XFS -- grow it online with xfs_growfs against the mount point."
    exit 1
fi

exit 0
