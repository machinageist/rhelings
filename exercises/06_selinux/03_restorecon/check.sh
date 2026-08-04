#!/usr/bin/env bash
# Pass condition: the file's actual context matches the policy default for its
# path, per `matchpathcon -V`.
set -uo pipefail

FILE="/var/www/html/index.html"

if [ ! -e "${FILE}" ]; then
    echo "${FILE} does not exist"
    exit 1
fi

output="$(matchpathcon -V "${FILE}" 2>&1)"
status=$?
echo "${output}"
exit "${status}"
