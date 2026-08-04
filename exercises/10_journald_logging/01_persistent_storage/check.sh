#!/usr/bin/env bash
# Pass condition: /etc/systemd/journald.conf has an uncommented
# Storage=persistent line, AND /var/log/journal exists (journald creates it
# automatically once persistent storage is configured and reloaded).
set -uo pipefail

CONFIG_FILE="/etc/systemd/journald.conf"

if ! grep -qx 'Storage=persistent' "${CONFIG_FILE}"; then
    echo "No uncommented 'Storage=persistent' line in ${CONFIG_FILE}:"
    grep '^Storage=' "${CONFIG_FILE}" || echo "(no Storage= line found)"
    exit 1
fi

if [ ! -d /var/log/journal ]; then
    echo "/var/log/journal does not exist yet -- restart systemd-journald to pick up the new setting."
    exit 1
fi

echo "Storage=persistent set, and /var/log/journal exists."
exit 0
