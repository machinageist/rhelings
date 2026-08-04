#!/usr/bin/env bash
# Idempotent: makes sure dbryant and opsteam and a second decoy group
# (billing) exist, dbryant is already a member of billing (to prove a wrong
# answer -- like `usermod -G opsteam` without `-a` -- would wipe it), and
# dbryant is NOT yet in opsteam.
set -euo pipefail

if ! getent group opsteam >/dev/null 2>&1; then
    groupadd opsteam
fi

if ! getent group billing >/dev/null 2>&1; then
    groupadd billing
fi

if ! id dbryant >/dev/null 2>&1; then
    useradd -m dbryant
fi

usermod -G billing dbryant
gpasswd -d dbryant opsteam 2>/dev/null || true
