#!/usr/bin/env bash
# Idempotent: creates a dummy1 interface (safe -- not the management NIC) with
# a manual-IPv4 connection profile that has no DNS servers set, so there's
# something to add.
set -euo pipefail

ip link show dummy1 >/dev/null 2>&1 || ip link add dummy1 type dummy
ip link set dummy1 up

nmcli connection delete dummy1-manual >/dev/null 2>&1 || true

nmcli connection add type dummy ifname dummy1 con-name dummy1-manual \
    ipv4.method manual ipv4.addresses 192.0.2.20/24 >/dev/null
