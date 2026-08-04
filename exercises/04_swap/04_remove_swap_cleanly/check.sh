#!/usr/bin/env bash
# Pass condition: /swapfile-decom is not active as swap, has no fstab entry,
# and no longer exists on disk.
set -uo pipefail

ok=1

if swapon --show=NAME --noheadings | grep -qx /swapfile-decom; then
    echo "/swapfile-decom is still active as swap."
    ok=0
fi

if grep -q 'swapfile-decom' /etc/fstab; then
    echo "/etc/fstab still has an entry referencing /swapfile-decom."
    ok=0
fi

if [ -e /swapfile-decom ]; then
    echo "/swapfile-decom still exists on disk."
    ok=0
fi

if [ "${ok}" -eq 1 ]; then
    echo "/swapfile-decom is fully decommissioned: inactive, no fstab entry, file removed."
fi

[ "${ok}" -eq 1 ]
