#!/usr/bin/env bash
# Pass condition: jsmith exists with UID 5010 and a home directory that exists.
set -uo pipefail

if ! id jsmith >/dev/null 2>&1; then
    echo "User jsmith does not exist."
    exit 1
fi

uid="$(id -u jsmith)"
echo "jsmith UID: ${uid}"

if [ "${uid}" != "5010" ]; then
    echo "Expected UID 5010, got ${uid}."
    exit 1
fi

home="$(getent passwd jsmith | cut -d: -f6)"
if [ ! -d "${home}" ]; then
    echo "jsmith's home directory (${home}) does not exist."
    exit 1
fi

echo "jsmith exists with UID 5010 and home ${home}."
exit 0
