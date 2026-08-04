#!/usr/bin/env bash
# Pass condition: errors.txt exists and contains exactly the ERROR lines from
# app.log, in original order -- no more, no less.
set -uo pipefail

LOG="/root/rhelings-lab/app.log"
OUT="/root/rhelings-lab/errors.txt"

if [ ! -e "${LOG}" ]; then
    echo "${LOG} is missing -- re-run setup (r) to recreate it."
    exit 1
fi

if [ ! -e "${OUT}" ]; then
    echo "${OUT} does not exist yet."
    exit 1
fi

expected="$(grep 'ERROR' "${LOG}")"
actual="$(cat "${OUT}")"

if [ "${expected}" = "${actual}" ]; then
    echo "errors.txt matches the expected ERROR lines:"
    echo "${actual}"
    exit 0
fi

echo "errors.txt does not match. Expected:"
echo "${expected}"
echo "---"
echo "Got:"
echo "${actual}"
exit 1
