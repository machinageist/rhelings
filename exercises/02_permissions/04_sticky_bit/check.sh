#!/usr/bin/env bash
# Pass condition: /srv/scratch is mode 1777 -- world-writable AND sticky.
set -uo pipefail

DIR="/srv/scratch"

if [ ! -d "${DIR}" ]; then
    echo "${DIR} does not exist -- re-run setup (r) to recreate it."
    exit 1
fi

mode="$(stat -c '%a' "${DIR}")"
echo "${DIR} mode: ${mode}"

if [ "${mode}" = "1777" ]; then
    exit 0
fi

if [ "${mode}" = "777" ]; then
    echo "Still world-writable but the sticky bit isn't set."
else
    echo "Mode changed from the expected 777 base -- leave the rwx bits alone, only add the sticky bit."
fi
exit 1
