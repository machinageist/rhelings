#!/usr/bin/env bash
# Idempotent: turns off and removes /swapfile-lab if a previous attempt
# created it, and strips any leftover fstab entry for it, so the exercise
# always starts from "no swapfile, nothing in fstab."
set -euo pipefail

if swapon --show=NAME --noheadings 2>/dev/null | grep -qx /swapfile-lab; then
    swapoff /swapfile-lab
fi

rm -f /swapfile-lab
sed -i '\#^/swapfile-lab[[:space:]]#d' /etc/fstab
