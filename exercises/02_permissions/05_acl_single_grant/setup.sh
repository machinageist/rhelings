#!/usr/bin/env bash
# Idempotent: makes sure the auditor user exists, (re)creates budget.csv owned
# root:root mode 640, and removes any ACL entries a previous attempt added.
set -euo pipefail

if ! id auditor >/dev/null 2>&1; then
    useradd -m auditor
fi

mkdir -p /root/rhelings-lab/finance
echo "line-item,amount" > /root/rhelings-lab/finance/budget.csv
echo "cloud,4200" >> /root/rhelings-lab/finance/budget.csv
chown root:root /root/rhelings-lab/finance/budget.csv
chmod 640 /root/rhelings-lab/finance/budget.csv

# Strip any ACL entries left over from a previous attempt at this exercise.
setfacl -b /root/rhelings-lab/finance/budget.csv
