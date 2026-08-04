#!/usr/bin/env bash
# Idempotent: sets PasswordAuthentication yes in sshd_config, so there's
# something to fix. Never reloads/restarts sshd -- config file only.
set -euo pipefail

CONFIG_FILE="/etc/ssh/sshd_config"

if grep -qE '^PasswordAuthentication' "${CONFIG_FILE}"; then
    sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' "${CONFIG_FILE}"
else
    echo "PasswordAuthentication yes" >> "${CONFIG_FILE}"
fi
