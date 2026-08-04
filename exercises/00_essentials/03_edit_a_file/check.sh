#!/usr/bin/env bash
# Pass condition: motd-lab.txt's content matches the required three lines
# exactly.
set -uo pipefail

FILE="/root/rhelings-lab/motd-lab.txt"

if [ ! -e "${FILE}" ]; then
    echo "${FILE} does not exist -- re-run setup (r) to recreate it."
    exit 1
fi

expected="Authorized access only.
All activity is logged.
Contact: labadmin@example.com"

actual="$(cat "${FILE}")"

if [ "${actual}" = "${expected}" ]; then
    echo "Content matches."
    exit 0
fi

echo "Content does not match. Expected exactly:"
echo "${expected}"
echo "---"
echo "Got:"
echo "${actual}"
exit 1
