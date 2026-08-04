#!/usr/bin/env bash
# Pass condition: a permanent rich rule in the default zone accepts TCP 9000
# from 192.0.2.0/24. Matches on the individual attributes rather than one
# exact string, since firewalld can reformat rich rule text on output.
set -uo pipefail

DEFAULT_ZONE="$(firewall-cmd --get-default-zone)"
rules="$(firewall-cmd --permanent --zone="${DEFAULT_ZONE}" --list-rich-rules)"
echo "Zone ${DEFAULT_ZONE} permanent rich rules:"
echo "${rules}"

matching="$(echo "${rules}" | grep 'source address="192.0.2.0/24"' | grep 'port="9000"' | grep 'protocol="tcp"' | grep -w 'accept')"

if [ -n "${matching}" ]; then
    exit 0
fi

echo "Expected a rich rule accepting tcp/9000 from source 192.0.2.0/24."
exit 1
