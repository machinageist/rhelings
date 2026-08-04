#!/usr/bin/env bash
# Idempotent: (re)installs rhelings-broken.service with an ExecStart= that
# points at a binary which doesn't exist, then tries to start it -- the
# start is SUPPOSED to fail (203/EXEC), so don't let that fail this script.
set -euo pipefail

cat > /etc/systemd/system/rhelings-broken.service <<'EOF'
[Unit]
Description=rhelings broken demo service

[Service]
ExecStart=/usr/bin/rhelings-nonexistent-binary
Restart=no

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl reset-failed rhelings-broken >/dev/null 2>&1 || true
systemctl start rhelings-broken >/dev/null 2>&1 || true
