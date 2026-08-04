#!/usr/bin/env bash
# Pass condition: tmpcontractor no longer exists in /etc/passwd AND
# /home/tmpcontractor no longer exists on disk.
set -uo pipefail

ok=1

if id tmpcontractor >/dev/null 2>&1; then
    echo "User tmpcontractor still exists."
    ok=0
fi

if [ -d /home/tmpcontractor ]; then
    echo "/home/tmpcontractor still exists -- delete the account with the flag that also removes the home directory."
    ok=0
fi

if [ "${ok}" -eq 1 ]; then
    echo "tmpcontractor and its home directory are both gone."
fi

[ "${ok}" -eq 1 ]
