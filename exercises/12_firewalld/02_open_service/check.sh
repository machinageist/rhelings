#!/usr/bin/env bash
# Pass condition: the http service is allowed (permanent config) in the
# default zone.
set -uo pipefail

DEFAULT_ZONE="$(firewall-cmd --get-default-zone)"
services="$(firewall-cmd --permanent --zone="${DEFAULT_ZONE}" --list-services)"
echo "Zone ${DEFAULT_ZONE} permanent services: ${services}"

if echo "${services}" | tr ' ' '\n' | grep -qx 'http'; then
    exit 0
fi

echo "http service not found in the permanent service list for zone ${DEFAULT_ZONE}."
exit 1
