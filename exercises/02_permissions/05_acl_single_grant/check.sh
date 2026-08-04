#!/usr/bin/env bash
# Pass condition: getfacl shows a named-user ACL entry granting auditor
# exactly read access, and the standard owner/group/mode are unchanged.
set -uo pipefail

FILE="/root/rhelings-lab/finance/budget.csv"

if [ ! -e "${FILE}" ]; then
    echo "${FILE} does not exist -- re-run setup (r) to recreate it."
    exit 1
fi

owner="$(stat -c '%U:%G' "${FILE}")"
mode="$(stat -c '%a' "${FILE}")"
echo "Owner: ${owner}, mode: ${mode}"

ok=1

if [ "${owner}" != "root:root" ]; then
    echo "Owner/group changed from root:root -- this should be an ACL grant, not an ownership change."
    ok=0
fi

acl="$(getfacl "${FILE}" 2>/dev/null)"
echo "${acl}"

if ! echo "${acl}" | grep -qE '^user:auditor:r--$'; then
    echo "Expected a 'user:auditor:r--' entry in the ACL -- read-only, not more."
    ok=0
fi

[ "${ok}" -eq 1 ]
