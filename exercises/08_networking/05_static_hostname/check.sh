#!/usr/bin/env bash
# Pass condition: the persistent static hostname is rhcsa-lab.example.com.
set -uo pipefail

current="$(hostnamectl --static)"
echo "Static hostname: ${current}"

if [ "${current}" = "rhcsa-lab.example.com" ]; then
    exit 0
fi

echo "Expected static hostname rhcsa-lab.example.com."
exit 1
