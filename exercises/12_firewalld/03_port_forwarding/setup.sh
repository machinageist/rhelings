#!/usr/bin/env bash
# Idempotent: makes sure the 8080->8443 forward-port rule is NOT present in
# the default zone yet, so there's something to add.
set -euo pipefail

DEFAULT_ZONE="$(firewall-cmd --get-default-zone)"

firewall-cmd --permanent --zone="${DEFAULT_ZONE}" \
    --remove-forward-port=port=8080:proto=tcp:toport=8443 >/dev/null 2>&1 || true
firewall-cmd --reload >/dev/null
