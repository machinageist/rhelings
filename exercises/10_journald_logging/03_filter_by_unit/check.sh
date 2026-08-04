#!/usr/bin/env bash
# Pass condition: the answer file contains exactly the text logged by
# rhelings-logtest.service.
set -uo pipefail

ANSWER_FILE="/root/rhelings-10-03-answer.txt"
EXPECTED="unit-scoped log line for filtering practice"

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
