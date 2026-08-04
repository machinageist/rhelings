#!/usr/bin/env bash
# Idempotent: (re)writes motd-lab.txt with deliberately wrong content so
# there's something to fix. Safe to re-run.
set -euo pipefail

mkdir -p /root/rhelings-lab

cat > /root/rhelings-lab/motd-lab.txt <<'EOF'
This file needs to be edited.
Replace this content with the exact text from task.md.
EOF
