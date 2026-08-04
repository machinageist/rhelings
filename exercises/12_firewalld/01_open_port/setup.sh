#!/usr/bin/env bash
# Idempotent: makes sure 8443/tcp is NOT open in the default zone yet, so
# there's something to add. Never touches SSH.
set -euo pipefail

DEFAULT_ZONE="$(firewall-cmd --get-default-zone)"

firewall-cmd --permanent --zone="${DEFAULT_ZONE}" --remove-port=8443/tcp >/dev/null 2>&1 || true
firewall-cmd --reload >/dev/null
