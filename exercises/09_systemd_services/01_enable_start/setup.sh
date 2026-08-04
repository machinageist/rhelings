#!/usr/bin/env bash
# Idempotent: (re)installs the rhelings-demo unit and makes sure it's stopped
# and disabled, so there's something to enable and start.
set -euo pipefail

cat > /etc/systemd/system/rhelings-demo.service <<'EOF'
[Unit]
Description=rhelings demo service

[Service]
ExecStart=/usr/bin/sleep infinity
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl disable --now rhelings-demo >/dev/null 2>&1 || true
