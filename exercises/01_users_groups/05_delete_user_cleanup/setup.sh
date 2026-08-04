#!/usr/bin/env bash
# Idempotent: (re)creates tmpcontractor with a home directory and a marker
# file, so there's always something to delete.
set -euo pipefail

if ! id tmpcontractor >/dev/null 2>&1; then
    useradd -m tmpcontractor
fi

mkdir -p /home/tmpcontractor
if [ ! -e /home/tmpcontractor/notes.txt ]; then
    echo "contractor notes" > /home/tmpcontractor/notes.txt
fi
