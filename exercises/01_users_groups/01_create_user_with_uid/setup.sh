#!/usr/bin/env bash
# Idempotent: removes jsmith (and its home) if a previous attempt created it
# with the wrong UID, so the exercise always starts from "user doesn't exist."
set -euo pipefail

if id jsmith >/dev/null 2>&1; then
    userdel -r jsmith 2>/dev/null || userdel jsmith
fi
