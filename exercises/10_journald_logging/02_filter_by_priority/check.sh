#!/usr/bin/env bash
# Pass condition: the answer file contains exactly the text of the one
# err-priority rhelings-batch message.
set -uo pipefail

ANSWER_FILE="/root/rhelings-10-02-answer.txt"
EXPECTED="batch job failed: unable to write output file"

if [ ! -f "${ANSWER_FILE}" ]; then
    echo "${ANSWER_FILE} does not exist yet."
    exit 1
fi

actual="$(tr -d '\n' < "${ANSWER_FILE}")"
echo "Expected: ${EXPECTED}"
echo "Found:    ${actual}"

if [ "${actual}" = "${EXPECTED}" ]; then
    exit 0
fi

exit 1
