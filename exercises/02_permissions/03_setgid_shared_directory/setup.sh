#!/usr/bin/env bash
# Idempotent: makes sure launchteam group exists, and (re)creates
# /srv/projects/launch owned by root:root with no setgid bit, wiping any
# leftover test file from a previous attempt.
set -euo pipefail

if ! getent group launchteam >/dev/null 2>&1; then
    groupadd launchteam
fi

mkdir -p /srv/projects/launch
chown root:root /srv/projects/launch
chmod 0775 /srv/projects/launch  # setgid explicitly OFF, in case a previous attempt set it
rm -f /srv/projects/launch/*
