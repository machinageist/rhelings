#!/usr/bin/env bash
# Pass condition: /etc/selinux/config has an uncommented SELINUX=enforcing line.
set -euo pipefail

CONFIG_FILE="/etc/selinux/config"

if grep -qx 'SELINUX=enforcing' "${CONFIG_FILE}"; then
    echo "Found: SELINUX=enforcing in ${CONFIG_FILE}"
    exit 0
fi

echo "Did not find an uncommented 'SELINUX=enforcing' line in ${CONFIG_FILE}:"
grep '^SELINUX=' "${CONFIG_FILE}" || echo "(no SELINUX= line found at all)"
exit 1
