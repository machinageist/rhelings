#!/usr/bin/env bash
# Pass condition: svcmon's shell is /sbin/nologin, its passwd home is
# /srv/svcmon, that directory exists and contains config.dat (proving the
# content moved, not just the account record), and the old /home/svcmon is
# gone.
set -uo pipefail

if ! id svcmon >/dev/null 2>&1; then
    echo "User svcmon does not exist -- re-run setup (r)."
    exit 1
fi

entry="$(getent passwd svcmon)"
echo "${entry}"

shell="$(echo "${entry}" | cut -d: -f7)"
home="$(echo "${entry}" | cut -d: -f6)"

ok=1

if [ "${shell}" != "/sbin/nologin" ]; then
    echo "Expected shell /sbin/nologin, got ${shell}."
    ok=0
fi

if [ "${home}" != "/srv/svcmon" ]; then
    echo "Expected home directory /srv/svcmon in passwd, got ${home}."
    ok=0
fi

if [ ! -f /srv/svcmon/config.dat ]; then
    echo "/srv/svcmon/config.dat is missing -- the existing home contents should have moved, not been left behind or recreated empty."
    ok=0
fi

if [ -d /home/svcmon ]; then
    echo "/home/svcmon still exists -- it should have been moved, not copied."
    ok=0
fi

[ "${ok}" -eq 1 ]
