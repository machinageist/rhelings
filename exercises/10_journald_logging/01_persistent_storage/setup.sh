#!/usr/bin/env bash
# Idempotent: sets Storage=volatile in journald.conf (not persistent) and
# restarts journald so there's something to fix.
set -euo pipefail

CONFIG_FILE="/etc/systemd/journald.conf"

if grep -q '^Storage=' "${CONFIG_FILE}"; then
    sed -i 's/^Storage=.*/Storage=volatile/' "${CONFIG_FILE}"
elif grep -q '^#Storage=' "${CONFIG_FILE}"; then
    sed -i 's/^#Storage=.*/Storage=volatile/' "${CONFIG_FILE}"
else
    echo "Storage=volatile" >> "${CONFIG_FILE}"
fi

systemctl restart systemd-journald
