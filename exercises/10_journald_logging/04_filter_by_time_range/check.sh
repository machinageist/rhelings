#!/usr/bin/env bash
# Pass condition: the answer file contains exactly the text of the one event
# that falls inside the recorded since/until window.
set -uo pipefail

ANSWER_FILE="/root/rhelings-10-04-answer.txt"
EXPECTED="event inside the window"

if [ ! -f "${ANSWER_FILE}" ]; then
    echo "${ANSWER_FILE} does not exist yet. See /root/rhelings-10-04-window.txt for the since/until values."
    exit 1
fi

actual="$(tr -d '\n' < "${ANSWER_FILE}")"
echo "Expected: ${EXPECTED}"
echo "Found:    ${actual}"

if [ "${actual}" = "${EXPECTED}" ]; then
    exit 0
fi

exit 1
