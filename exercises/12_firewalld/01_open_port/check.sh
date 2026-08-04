#!/usr/bin/env bash
# Pass condition: 8443/tcp is open (permanent config) in the default zone.
set -uo pipefail

DEFAULT_ZONE="$(firewall-cmd --get-default-zone)"
ports="$(firewall-cmd --permanent --zone="${DEFAULT_ZONE}" --list-ports)"
echo "Zone ${DEFAULT_ZONE} permanent ports: ${ports}"

if echo "${ports}" | tr ' ' '\n' | grep -qx '8443/tcp'; then
    exit 0
fi

echo "8443/tcp not found in the permanent port list for zone ${DEFAULT_ZONE}."
exit 1
