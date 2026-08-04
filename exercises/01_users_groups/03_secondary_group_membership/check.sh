#!/usr/bin/env bash
# Pass condition: dbryant is a member of opsteam AND still a member of billing
# (proving the existing secondary group wasn't clobbered) AND their primary
# group is still their own private group, not opsteam.
set -uo pipefail

if ! id dbryant >/dev/null 2>&1; then
    echo "User dbryant does not exist -- re-run setup (r)."
    exit 1
fi

groups="$(id -nG dbryant)"
echo "dbryant's groups: ${groups}"

ok=1

if ! echo "${groups}" | grep -qw opsteam; then
    echo "dbryant is not in opsteam yet."
    ok=0
fi

if ! echo "${groups}" | grep -qw billing; then
    echo "dbryant is no longer in billing -- did you use 'usermod -G' without '-a'?"
    echo "That replaces the whole secondary group list instead of adding to it."
    ok=0
fi

primary_group="$(id -gn dbryant)"
if [ "${primary_group}" != "dbryant" ]; then
    echo "dbryant's primary group changed to ${primary_group} -- it should still be their own private group (dbryant)."
    ok=0
fi

[ "${ok}" -eq 1 ]
