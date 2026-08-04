#!/usr/bin/env bash
# Pass condition: group webteam exists with GID 6001.
set -uo pipefail

entry="$(getent group webteam)"
if [ -z "${entry}" ]; then
    echo "Group webteam does not exist."
    exit 1
fi

echo "${entry}"

gid="$(echo "${entry}" | cut -d: -f3)"
if [ "${gid}" != "6001" ]; then
    echo "Expected GID 6001, got ${gid}."
    exit 1
fi

exit 0
