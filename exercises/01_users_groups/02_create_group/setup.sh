#!/usr/bin/env bash
# Idempotent: removes webteam if a previous attempt created it with the wrong
# GID, so the exercise always starts from "group doesn't exist."
set -euo pipefail

if getent group webteam >/dev/null 2>&1; then
    groupdel webteam
fi
