#!/usr/bin/env bash
# Idempotent: (re)creates two active 64MB swap files with equal (default)
# priority and matching fstab entries with no pri= option -- the "not
# prioritized yet" starting state. Safe to re-run even after a previous
# attempt already set priorities.
set -euo pipefail

for name in fast slow; do
    file="/swapfile-${name}"
    sed -i "\#${file}#d" /etc/fstab
    if swapon --show=NAME --noheadings 2>/dev/null | grep -qx "${file}"; then
        swapoff "${file}"
    fi
    rm -f "${file}"
    dd if=/dev/zero of="${file}" bs=1M count=64 status=none
    chmod 600 "${file}"
    mkswap "${file}" >/dev/null
    swapon "${file}"
    echo "${file}  none  swap  sw  0  0" >> /etc/fstab
done
