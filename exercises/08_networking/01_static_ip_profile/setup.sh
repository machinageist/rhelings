#!/usr/bin/env bash
# Idempotent: creates a dummy0 interface (safe -- not the management NIC) and
# removes any existing NetworkManager connection profile bound to it, so
# there's a clean slate to create a new static profile against.
set -euo pipefail

ip link show dummy0 >/dev/null 2>&1 || ip link add dummy0 type dummy
ip link set dummy0 up

nmcli -t -f NAME,DEVICE connection show 2>/dev/null \
    | awk -F: '$2 == "dummy0" { print $1 }' \
    | while IFS= read -r name; do
        nmcli connection delete "${name}" >/dev/null 2>&1 || true
      done
