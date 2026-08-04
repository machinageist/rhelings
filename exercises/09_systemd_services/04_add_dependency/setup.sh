#!/usr/bin/env bash
# Idempotent: (re)installs rhelings-demo WITHOUT the network-online.target
# dependency, so there's something to add.
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
