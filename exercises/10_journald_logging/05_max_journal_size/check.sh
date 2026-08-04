#!/usr/bin/env bash
# Pass condition: /etc/systemd/journald.conf has an uncommented
# SystemMaxUse=50M line.
set -uo pipefail

CONFIG_FILE="/etc/systemd/journald.conf"

if grep -qx 'SystemMaxUse=50M' "${CONFIG_FILE}"; then
    echo "Found: SystemMaxUse=50M in ${CONFIG_FILE}"
    exit 0
fi

echo "Did not find an uncommented 'SystemMaxUse=50M' line in ${CONFIG_FILE}:"
grep '^SystemMaxUse=' "${CONFIG_FILE}" || echo "(no SystemMaxUse= line found)"
exit 1
