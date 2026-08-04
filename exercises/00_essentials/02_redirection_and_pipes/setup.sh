#!/usr/bin/env bash
# Idempotent: (re)writes a fixed, known-content app.log so errors.txt has a
# deterministic expected answer. Removes any errors.txt left over from a
# previous attempt.
set -euo pipefail

mkdir -p /root/rhelings-lab

cat > /root/rhelings-lab/app.log <<'EOF'
2026-08-03 09:00:01 INFO  service started
2026-08-03 09:00:05 INFO  listening on port 8080
2026-08-03 09:01:12 ERROR failed to connect to database
2026-08-03 09:01:13 INFO  retrying connection
2026-08-03 09:01:14 ERROR retry failed: timeout
2026-08-03 09:02:00 INFO  connection established
2026-08-03 09:05:30 WARN  slow query took 2.3s
2026-08-03 09:10:45 ERROR disk usage above 90%
EOF

rm -f /root/rhelings-lab/errors.txt
