#!/usr/bin/env bash
# Pass condition: both stashed devices are recognized PVs, and vg_data01
# exists and includes both of them.
set -uo pipefail

STASH="/var/tmp/rhelings/05_lvm_01_pvcreate_vgcreate.loopdevs"

if [ ! -f "${STASH}" ]; then
    echo "No scratch devices recorded -- re-run setup (r)."
    exit 1
fi

ok=1
while IFS= read -r dev; do
    [ -z "${dev}" ] && continue
    if [ ! -b "${dev}" ]; then
        echo "${dev} is not a block device -- re-run setup (r) to reattach it."
        ok=0
        continue
    fi
    if ! pvs --noheadings -o pv_name "${dev}" >/dev/null 2>&1; then
        echo "${dev} is not initialized as a PV yet (pvcreate)."
        ok=0
    fi
done < "${STASH}"

if [ "${ok}" -ne 1 ]; then
    exit 1
fi

if ! vgs vg_data01 >/dev/null 2>&1; then
    echo "Volume group vg_data01 does not exist yet."
    exit 1
fi

vg_pvs="$(vgs --noheadings -o pv_count vg_data01 | tr -d ' ')"
echo "vg_data01 PV count: ${vg_pvs}"

if [ "${vg_pvs}" != "2" ]; then
    echo "Expected vg_data01 to include both PVs (pv_count=2), got ${vg_pvs}."
    exit 1
fi

pvs
vgs vg_data01
exit 0
