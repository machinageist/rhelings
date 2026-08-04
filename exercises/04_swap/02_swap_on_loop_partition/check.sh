#!/usr/bin/env bash
# Pass condition: the stashed partition is formatted as swap, currently
# active, and has a persistent UUID-based fstab entry.
set -uo pipefail

STASH="/var/tmp/rhelings/04_swap_02_swap_on_loop_partition.partition"

if [ ! -f "${STASH}" ]; then
    echo "No scratch partition recorded -- re-run setup (r)."
    exit 1
fi

PART="$(cat "${STASH}")"
if [ ! -b "${PART}" ]; then
    echo "${PART} is not a block device -- re-run setup (r) to recreate it."
    exit 1
fi

fstype="$(blkid -s TYPE -o value "${PART}" 2>/dev/null || true)"
echo "Filesystem type: ${fstype:-<none>}"

ok=1

if [ "${fstype}" != "swap" ]; then
    echo "${PART} is not formatted as swap yet (mkswap)."
    ok=0
fi

if ! swapon --show=NAME --noheadings | grep -qx "${PART}"; then
    echo "${PART} is not currently active as swap. Current swap:"
    swapon --show
    ok=0
fi

uuid="$(blkid -s UUID -o value "${PART}" 2>/dev/null || true)"
if [ -z "${uuid}" ]; then
    echo "Could not read a UUID from ${PART}."
    ok=0
elif ! grep -qE "^UUID=${uuid}[[:space:]]" /etc/fstab; then
    echo "/etc/fstab has no UUID=${uuid} entry for this swap partition."
    ok=0
fi

[ "${ok}" -eq 1 ]
