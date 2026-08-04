#!/usr/bin/env bash
# Pass condition: a permanent forward-port rule sends 8080/tcp to 8443 in the
# default zone.
set -uo pipefail

DEFAULT_ZONE="$(firewall-cmd --get-default-zone)"
forwards="$(firewall-cmd --permanent --zone="${DEFAULT_ZONE}" --list-forward-ports)"
echo "Zone ${DEFAULT_ZONE} permanent forward ports:"
echo "${forwards}"

if echo "${forwards}" | grep -q 'port=8080:proto=tcp:toport=8443'; then
    exit 0
fi

echo "Expected a forward-port rule for port=8080:proto=tcp:toport=8443."
exit 1
