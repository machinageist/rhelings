#!/usr/bin/env bash
# Idempotent: creates a real, valid 128MB swap file at /swapfile-diag
# (mkswap'd but deliberately not swapon'd), then writes a broken fstab entry
# that points at the WRONG filename (/swapfile-diag-old, which doesn't exist)
# -- a realistic typo/stale-entry scenario. Cleans up any active swap and
# fstab entries from a previous attempt first so this always starts the same
# way.
set -euo pipefail

if swapon --show=NAME --noheadings 2>/dev/null | grep -qx /swapfile-diag; then
    swapoff /swapfile-diag
fi

sed -i '\#swapfile-diag#d' /etc/fstab

rm -f /swapfile-diag
dd if=/dev/zero of=/swapfile-diag bs=1M count=128 status=none
chmod 600 /swapfile-diag
mkswap /swapfile-diag >/dev/null

echo "/swapfile-diag-old  none  swap  sw  0  0" >> /etc/fstab
