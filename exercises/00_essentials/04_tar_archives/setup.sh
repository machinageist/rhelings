#!/usr/bin/env bash
# Idempotent: rebuilds bundle.tar.gz from scratch and removes any
# already-extracted bundle/ dir or previous bundle-updated.tar.gz so the
# exercise always starts from "only the archive exists."
set -euo pipefail

LAB="/root/rhelings-lab"
STAGE="$(mktemp -d)"

rm -rf "${LAB}/bundle" "${LAB}/bundle-updated.tar.gz"
mkdir -p "${LAB}" "${STAGE}/bundle/data"

echo "these are notes" > "${STAGE}/bundle/notes.txt"
printf 'id,value\n1,10\n2,20\n' > "${STAGE}/bundle/data/values.csv"

tar -czf "${LAB}/bundle.tar.gz" -C "${STAGE}" bundle
rm -rf "${STAGE}"
