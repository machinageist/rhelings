#!/usr/bin/env bash
# Idempotent: makes sure the package providing `killall` (psmisc) is NOT
# installed, so there's something to find and install.
set -euo pipefail

dnf remove -y psmisc >/dev/null 2>&1 || true
