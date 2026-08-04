#!/usr/bin/env bash
# Idempotent: creates a dummy2 interface (safe -- not the management NIC)
# with a static profile that is defined but NOT activated, so there's
# something to bring up.
set -euo pipefail

ip link show dummy2 >/dev/null 2>&1 || ip link add dummy2 type dummy
ip link set dummy2 up

nmcli connection delete dummy2-static >/dev/null 2>&1 || true

nmcli connection add type dummy ifname dummy2 con-name dummy2-static \
    ipv4.method manual ipv4.addresses 192.0.2.30/24 \
    connection.autoconnect no >/dev/null

nmcli connection down dummy2-static >/dev/null 2>&1 || true
