#!/usr/bin/env bash
# Pass condition: a custom fcontext rule exists for /srv/web(/.*)? AND the
# actual file context matches what that rule (now the policy default) expects.
set -uo pipefail

FILE="/srv/web/index.html"

if [ ! -e "${FILE}" ]; then
    echo "${FILE} does not exist"
    exit 1
fi

if ! semanage fcontext -l | grep -qF '/srv/web(/.*)?'; then
    echo "No custom fcontext rule found for /srv/web(/.*)? -- add one first with:"
    echo '  semanage fcontext -a -t httpd_sys_content_t "/srv/web(/.*)?"'
    exit 1
fi

output="$(matchpathcon -V "${FILE}" 2>&1)"
status=$?
echo "${output}"
exit "${status}"
