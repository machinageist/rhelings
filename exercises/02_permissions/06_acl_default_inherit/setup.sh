#!/usr/bin/env bash
# Idempotent: makes sure the reviewer user exists, (re)creates
# /srv/shared/incoming with no ACLs, and clears any leftover test file.
set -euo pipefail

if ! id reviewer >/dev/null 2>&1; then
    useradd -m reviewer
fi

mkdir -p /srv/shared/incoming
setfacl -b /srv/shared/incoming
rm -f /srv/shared/incoming/*
