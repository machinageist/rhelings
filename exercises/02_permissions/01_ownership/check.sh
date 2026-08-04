#!/usr/bin/env bash
# Pass condition: every file and directory under deploy/ is owned by
# appsvc:appteam, no exceptions.
set -uo pipefail

DIR="/root/rhelings-lab/deploy"

if [ ! -d "${DIR}" ]; then
    echo "${DIR} does not exist -- re-run setup (r) to recreate it."
    exit 1
fi

bad="$(find "${DIR}" ! -user appsvc -o ! -group appteam 2>/dev/null)"

if [ -n "${bad}" ]; then
    echo "These paths are not owned appsvc:appteam yet:"
    echo "${bad}"
    exit 1
fi

echo "Everything under ${DIR} is owned appsvc:appteam:"
find "${DIR}" -printf '%u:%g %p\n'
exit 0
