#!/usr/bin/env bash
# Pass condition: bundle/ was extracted with its original two files intact,
# summary.txt was added with the right content, and bundle-updated.tar.gz
# contains all four files.
set -uo pipefail

LAB="/root/rhelings-lab"

if [ ! -f "${LAB}/bundle/notes.txt" ] || [ ! -f "${LAB}/bundle/data/values.csv" ]; then
    echo "${LAB}/bundle/ is missing its original extracted files."
    echo "Extract bundle.tar.gz into ${LAB}/ first."
    exit 1
fi

if [ ! -f "${LAB}/bundle/data/summary.txt" ]; then
    echo "${LAB}/bundle/data/summary.txt does not exist yet."
    exit 1
fi

summary="$(cat "${LAB}/bundle/data/summary.txt")"
if [ "${summary}" != "done" ]; then
    echo "summary.txt should contain exactly 'done', got: '${summary}'"
    exit 1
fi

if [ ! -f "${LAB}/bundle-updated.tar.gz" ]; then
    echo "${LAB}/bundle-updated.tar.gz does not exist yet."
    exit 1
fi

listing="$(tar -tzf "${LAB}/bundle-updated.tar.gz" 2>&1)"
status=$?
if [ "${status}" -ne 0 ]; then
    echo "bundle-updated.tar.gz is not a valid gzip tarball:"
    echo "${listing}"
    exit 1
fi

missing=0
for member in "bundle/notes.txt" "bundle/data/values.csv" "bundle/data/summary.txt"; do
    if ! echo "${listing}" | grep -qF "${member}"; then
        echo "bundle-updated.tar.gz is missing ${member}"
        missing=1
    fi
done

if [ "${missing}" -ne 0 ]; then
    echo "Archive contents were:"
    echo "${listing}"
    exit 1
fi

echo "bundle-updated.tar.gz contains all expected files:"
echo "${listing}"
exit 0
