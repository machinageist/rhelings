#!/usr/bin/env bash
# Pass condition: the directory has both a regular ACL entry AND a default
# ACL entry for reviewer:r--, and a freshly-created file inside it actually
# inherits a reviewer:r-- entry -- the real proof, not just the default ACL
# existing on the directory.
set -uo pipefail

DIR="/srv/shared/incoming"

if [ ! -d "${DIR}" ]; then
    echo "${DIR} does not exist -- re-run setup (r) to recreate it."
    exit 1
fi

acl="$(getfacl "${DIR}" 2>/dev/null)"
echo "${acl}"

ok=1

if ! echo "${acl}" | grep -qE '^user:reviewer:r--$'; then
    echo "Missing a regular 'user:reviewer:r--' ACL entry on the directory itself."
    ok=0
fi

if ! echo "${acl}" | grep -qE '^default:user:reviewer:r--$'; then
    echo "Missing a 'default:user:reviewer:r--' entry -- that's what makes new files inherit the grant."
    ok=0
fi

testfile="${DIR}/.rhelings-acl-test"
rm -f "${testfile}"
touch "${testfile}"
testacl="$(getfacl "${testfile}" 2>/dev/null)"
rm -f "${testfile}"

if ! echo "${testacl}" | grep -qE '^user:reviewer:r--$'; then
    echo "A newly-created file did not inherit a reviewer:r-- ACL entry -- the default ACL isn't actually applying."
    echo "${testacl}"
    ok=0
fi

[ "${ok}" -eq 1 ]
