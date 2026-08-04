#!/usr/bin/env bash
# Idempotent: logs three rhelings-window events spaced a couple seconds
# apart, records the since/until boundaries that isolate the middle one, and
# clears any previous answer file. Re-running just produces a fresh window
# with fresh timestamps -- the correct answer text never changes.
set -euo pipefail

WINDOW_FILE="/root/rhelings-10-04-window.txt"

logger -t rhelings-window "event before the window"
sleep 2
start="$(date '+%Y-%m-%d %H:%M:%S')"
sleep 1
logger -t rhelings-window "event inside the window"
sleep 1
end="$(date '+%Y-%m-%d %H:%M:%S')"
sleep 2
logger -t rhelings-window "event after the window"

printf 'since: %s\nuntil: %s\n' "${start}" "${end}" > "${WINDOW_FILE}"

rm -f /root/rhelings-10-04-answer.txt
