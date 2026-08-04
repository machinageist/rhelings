#!/usr/bin/env bash
# Idempotent: (re)installs the rhelings-demo unit and makes sure it's running
# and enabled, so there's something to stop and disable.
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
systemctl enable --now rhelings-demo >/dev/null
