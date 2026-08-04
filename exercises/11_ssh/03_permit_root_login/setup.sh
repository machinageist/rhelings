#!/usr/bin/env bash
# Idempotent: sets PermitRootLogin yes in sshd_config, so there's something
# to fix. Never reloads/restarts sshd -- config file only.
set -euo pipefail

CONFIG_FILE="/etc/ssh/sshd_config"

if grep -qE '^PermitRootLogin' "${CONFIG_FILE}"; then
    sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' "${CONFIG_FILE}"
else
    echo "PermitRootLogin yes" >> "${CONFIG_FILE}"
fi
