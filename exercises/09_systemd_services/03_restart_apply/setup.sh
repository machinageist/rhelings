#!/usr/bin/env bash
# Idempotent: (re)installs the rhelings-demo unit, starts it, and records its
# activation timestamp to a marker file. check.sh compares against this
# marker to tell whether the learner actually restarted the unit afterward,
# rather than just leaving it running from setup.
set -euo pipefail

MARKER="/var/tmp/rhelings-09-03-marker"

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

systemctl show rhelings-demo -p ActiveEnterTimestampMonotonic --value > "${MARKER}"
