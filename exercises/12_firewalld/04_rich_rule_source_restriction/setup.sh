#!/usr/bin/env bash
# Idempotent: makes sure the target rich rule is NOT present in the default
# zone yet, so there's something to add. Never touches ssh.
set -euo pipefail

DEFAULT_ZONE="$(firewall-cmd --get-default-zone)"
RULE='rule family="ipv4" source address="192.0.2.0/24" port port="9000" protocol="tcp" accept'

firewall-cmd --permanent --zone="${DEFAULT_ZONE}" --remove-rich-rule="${RULE}" >/dev/null 2>&1 || true
firewall-cmd --reload >/dev/null
