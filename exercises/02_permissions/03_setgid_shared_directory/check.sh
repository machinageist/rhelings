#!/usr/bin/env bash
# Pass condition: the directory's group is launchteam, the setgid bit is set,
# AND a freshly-created file inside it actually inherits the launchteam group
# (the real proof, not just the bit being set).
set -uo pipefail

DIR="/srv/projects/launch"

if [ ! -d "${DIR}" ]; then
    echo "${DIR} does not exist -- re-run setup (r) to recreate it."
    exit 1
fi

group="$(stat -c '%G' "${DIR}")"
mode="$(stat -c '%a' "${DIR}")"
echo "${DIR}: group=${group} mode=${mode}"

ok=1

if [ "${group}" != "launchteam" ]; then
    echo "Expected group launchteam, got ${group}."
    ok=0
fi

# setgid shows as the leading digit '2' in a 4-digit octal mode.
if [ "${#mode}" -ne 4 ] || [ "${mode:0:1}" != "2" ]; then
    echo "setgid bit is not set (expected a 4-digit mode starting with 2, e.g. 2775)."
    ok=0
fi

testfile="${DIR}/.rhelings-setgid-test"
rm -f "${testfile}"
touch "${testfile}"
testgroup="$(stat -c '%G' "${testfile}")"
rm -f "${testfile}"

if [ "${testgroup}" != "launchteam" ]; then
    echo "A new file created in ${DIR} got group '${testgroup}', not launchteam -- setgid isn't actually inheriting."
    ok=0
fi

[ "${ok}" -eq 1 ]
