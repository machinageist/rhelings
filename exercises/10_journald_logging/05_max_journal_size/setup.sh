#!/usr/bin/env bash
# Idempotent: removes any SystemMaxUse= line from journald.conf, so there's
# no cap configured yet.
set -euo pipefail

CONFIG_FILE="/etc/systemd/journald.conf"

sed -i '/^SystemMaxUse=/d' "${CONFIG_FILE}"
