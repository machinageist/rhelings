#!/usr/bin/env bash
# Idempotent: makes sure `tree` is NOT installed, so there's something to install.
set -euo pipefail

dnf remove -y tree >/dev/null 2>&1 || true
