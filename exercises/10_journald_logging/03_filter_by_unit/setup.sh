#!/usr/bin/env bash
# Idempotent: (re)installs and runs a trivial oneshot unit that logs a fixed
# message, then clears any previous answer file.
set -euo pipefail

cat > /etc/systemd/system/rhelings-logtest.service <<'EOF'
[Unit]
Description=rhelings journald filter test

[Service]
Type=oneshot
ExecStart=/usr/bin/logger -t rhelings-logtest "unit-scoped log line for filtering practice"
EOF

systemctl daemon-reload
systemctl start rhelings-logtest.service

rm -f /root/rhelings-10-03-answer.txt
