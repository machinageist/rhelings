#!/usr/bin/env bash
# Pass condition: a custom fcontext rule exists for /srv/appdata(/.*)? AND the
# actual file context matches it. (Same shape as the semanage_fcontext exercise
# -- the point of this one is finding the problem, not a different fix.)
set -uo pipefail

FILE="/srv/appdata/data.txt"

if [ ! -e "${FILE}" ]; then
    echo "${FILE} does not exist"
    exit 1
fi

if ! semanage fcontext -l | grep -qF '/srv/appdata(/.*)?'; then
    echo "No custom fcontext rule found for /srv/appdata(/.*)? yet."
    echo "Start with: ausearch -m avc -ts recent"
    exit 1
fi

output="$(matchpathcon -V "${FILE}" 2>&1)"
status=$?
echo "${output}"
exit "${status}"
