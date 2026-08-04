#!/usr/bin/env bash
# Idempotent: resets the static hostname to a generic default so there's
# something to fix.
set -euo pipefail

hostnamectl set-hostname localhost.localdomain
