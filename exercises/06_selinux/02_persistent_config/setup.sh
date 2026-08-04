#!/usr/bin/env bash
# Idempotent: sets the persistent SELINUX= line in /etc/selinux/config to
# "permissive" so there's something to fix. Safe to run repeatedly.
set -euo pipefail

CONFIG_FILE="/etc/selinux/config"

if grep -q '^SELINUX=' "${CONFIG_FILE}"; then
    sed -i 's/^SELINUX=.*/SELINUX=permissive/' "${CONFIG_FILE}"
else
    echo "SELINUX=permissive" >> "${CONFIG_FILE}"
fi
