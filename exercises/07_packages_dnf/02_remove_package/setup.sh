#!/usr/bin/env bash
# Idempotent: makes sure `zsh` IS installed, so there's something to remove.
set -euo pipefail

dnf install -y zsh >/dev/null 2>&1
