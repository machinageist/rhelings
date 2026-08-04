#!/usr/bin/env bash
# Pass condition: /swapfile-diag is currently active as swap AND
# /etc/fstab's entry for it points at the real, existing path (not the
# stale/wrong one from setup) AND `swapon -a` runs clean.
set -uo pipefail

ok=1

if ! swapon --show=NAME --noheadings | grep -qx /swapfile-diag; then
    echo "/swapfile-diag is not currently active as swap. Current swap:"
    swapon --show
    ok=0
fi

if grep -q 'swapfile-diag-old' /etc/fstab; then
    echo "/etc/fstab still references the stale /swapfile-diag-old path."
    ok=0
fi

if ! grep -qE '^/swapfile-diag[[:space:]]' /etc/fstab; then
    echo "/etc/fstab has no correct entry for /swapfile-diag."
    ok=0
fi

swapon_output="$(swapon -a 2>&1)"
status=$?
if [ "${status}" -ne 0 ]; then
    echo "'swapon -a' still fails:"
    echo "${swapon_output}"
    ok=0
fi

[ "${ok}" -eq 1 ]
