#!/usr/bin/env bash
# Pass condition: the nested directory tree exists and contains q3.txt.
set -uo pipefail

DIR="/root/rhelings-lab/archive/2026/reports"
FILE="${DIR}/q3.txt"

if [ ! -d "${DIR}" ]; then
    echo "${DIR} does not exist."
    echo "Create it (and its parents) in one command -- check 'man mkdir' for the flag."
    exit 1
fi

if [ ! -e "${FILE}" ]; then
    echo "${DIR} exists, but ${FILE} does not."
    echo "Create an empty file named q3.txt inside it."
    exit 1
fi

echo "Found ${FILE}."
exit 0
