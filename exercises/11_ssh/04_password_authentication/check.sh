#!/usr/bin/env bash
# Pass condition: sshd_config is syntactically valid AND the EFFECTIVE config
# (sshd -T, resolving any /etc/ssh/sshd_config.d/*.conf drop-in overrides)
# has PasswordAuthentication set to no. Never reloads/restarts sshd.
set -uo pipefail

if ! sshd -t 2>/tmp/rhelings-11-04-err; then
    echo "sshd -t reports a config syntax error:"
    cat /tmp/rhelings-11-04-err
    exit 1
fi

effective="$(sshd -T | grep -i '^passwordauthentication ')"
echo "Effective config: ${effective}"

if echo "${effective}" | grep -qiw 'no'; then
    exit 0
fi

echo "Expected 'passwordauthentication no' in the effective sshd config."
exit 1
