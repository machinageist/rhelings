#!/usr/bin/env bash
# Idempotent: makes sure nmap-ncat is installed as the most recent DNF
# transaction, so there's a transaction to find and undo. If it's already
# installed (e.g. a previous attempt undid it and this re-installs it), the
# package still ends up present with an install as the latest history entry.
set -euo pipefail

dnf install -y nmap-ncat >/dev/null 2>&1
