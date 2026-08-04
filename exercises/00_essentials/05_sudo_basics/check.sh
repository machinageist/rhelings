#!/usr/bin/env bash
# Pass condition: /etc/sudoers.d/ has a file that's syntactically valid AND
# `sudo -l -U labtech` actually reports the NOPASSWD grant for exactly that
# command -- checking the live grant, not just guessing from file text, so a
# rule that's present but broken (bad syntax elsewhere, wrong user, etc.)
# still fails.
set -uo pipefail

if ! id labtech >/dev/null 2>&1; then
    echo "labtech does not exist -- re-run setup (r)."
    exit 1
fi

if id -nG labtech | grep -qw wheel; then
    echo "labtech is in the wheel group -- that's full root access, broader than asked."
    exit 1
fi

# visudo -c checks every file in /etc/sudoers.d/, so a bad drop-in here would
# be caught even if it's not the one this check inspects directly.
syntax_output="$(visudo -c 2>&1)"
if [ $? -ne 0 ]; then
    echo "sudoers syntax check failed:"
    echo "${syntax_output}"
    exit 1
fi

grant="$(sudo -l -U labtech 2>&1)"
echo "${grant}"

if echo "${grant}" | grep -q 'NOPASSWD' && echo "${grant}" | grep -qF '/usr/bin/systemctl status sshd'; then
    exit 0
fi

echo "Expected sudo -l -U labtech to show a NOPASSWD grant for exactly"
echo "/usr/bin/systemctl status sshd."
exit 1
