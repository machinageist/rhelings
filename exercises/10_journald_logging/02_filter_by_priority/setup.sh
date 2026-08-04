#!/usr/bin/env bash
# Idempotent: logs a fresh set of rhelings-batch messages at various
# priorities (re-running just adds more identical-content entries, which
# doesn't change the correct answer) and clears any previous answer file.
set -euo pipefail

logger -t rhelings-batch -p user.info "batch job started"
logger -t rhelings-batch -p user.warning "disk usage climbing"
logger -t rhelings-batch -p user.err "batch job failed: unable to write output file"
logger -t rhelings-batch -p user.info "batch job cleanup complete"

rm -f /root/rhelings-10-02-answer.txt
