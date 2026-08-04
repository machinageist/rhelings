#!/usr/bin/env bash
# Idempotent: (re)creates /srv/scratch as world-writable (777) with the
# sticky bit explicitly off.
set -euo pipefail

mkdir -p /srv/scratch
chmod 0777 /srv/scratch
