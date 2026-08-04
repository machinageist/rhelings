#!/usr/bin/env bash
# Idempotent: makes sure svcmon exists with shell /bin/bash and home
# /home/svcmon containing a marker file. If a previous attempt already moved
# the home directory to /srv/svcmon, move it back to /home/svcmon first so
# the exercise always starts from the same broken state.
set -euo pipefail

if id svcmon >/dev/null 2>&1; then
    current_home="$(getent passwd svcmon | cut -d: -f6)"
    if [ "${current_home}" != "/home/svcmon" ]; then
        usermod -d /home/svcmon -m svcmon 2>/dev/null || true
    fi
    usermod -s /bin/bash svcmon
else
    useradd -m -s /bin/bash svcmon
fi

mkdir -p /home/svcmon
if [ ! -e /home/svcmon/config.dat ]; then
    echo "service config placeholder" > /home/svcmon/config.dat
fi
