#!/usr/bin/env bash
# Idempotent: makes sure the http service is NOT allowed in the default
# zone yet, so there's something to add. Never touches ssh.
set -euo pipefail

DEFAULT_ZONE="$(firewall-cmd --get-default-zone)"

firewall-cmd --permanent --zone="${DEFAULT_ZONE}" --remove-service=http >/dev/null 2>&1 || true
firewall-cmd --reload >/dev/null
