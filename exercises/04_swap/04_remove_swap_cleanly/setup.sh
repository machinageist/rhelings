#!/usr/bin/env bash
# Idempotent: (re)creates /swapfile-decom as a real, active swap file with a
# matching persistent fstab entry -- the "still in use" starting state this
# exercise asks you to tear down. Safe to re-run even if a previous attempt
# already removed it.
set -euo pipefail

sed -i '\#swapfile-decom#d' /etc/fstab

if swapon --show=NAME --noheadings 2>/dev/null | grep -qx /swapfile-decom; then
    swapoff /swapfile-decom
fi

rm -f /swapfile-decom
dd if=/dev/zero of=/swapfile-decom bs=1M count=128 status=none
chmod 600 /swapfile-decom
mkswap /swapfile-decom >/dev/null
swapon /swapfile-decom

echo "/swapfile-decom  none  swap  sw  0  0" >> /etc/fstab
