#!/usr/bin/env bash
# Pass condition: vg_data06 now has 2 PVs (the new one added), lv_grow has
# grown well past its original 400M (proving it was extended into the new
# space), and the mounted XFS filesystem reflects that growth too.
set -uo pipefail

STASH="/var/tmp/rhelings/05_lvm_06_vgextend_new_pv.newdev"

if [ ! -f "${STASH}" ]; then
    echo "No new-PV device recorded -- re-run setup (r)."
    exit 1
fi

NEWDEV="$(cat "${STASH}")"

if ! vgs vg_data06 >/dev/null 2>&1; then
    echo "vg_data06 does not exist -- re-run setup (r)."
    exit 1
fi

pv_count="$(vgs --noheadings -o pv_count vg_data06 | tr -d ' ')"
echo "vg_data06 PV count: ${pv_count}"

ok=1
if [ "${pv_count}" != "2" ]; then
    echo "Expected vg_data06 to have 2 PVs after adding ${NEWDEV} with vgextend, got ${pv_count}."
    ok=0
fi

if ! lvs vg_data06/lv_grow >/dev/null 2>&1; then
    echo "vg_data06/lv_grow does not exist."
    exit 1
fi

lv_mib="$(lvs --noheadings --units m -o lv_size --nosuffix vg_data06/lv_grow | tr -d ' ')"
lv_mib_int="${lv_mib%%.*}"
echo "lv_grow size: ${lv_mib}M"

if [ "${lv_mib_int}" -lt 800 ]; then
    echo "Expected lv_grow extended well past its original 400M (into the new PV's space), got ${lv_mib}M."
    ok=0
fi

if ! mountpoint -q /mnt/xfs-vgextend; then
    echo "/mnt/xfs-vgextend is not mounted."
    ok=0
else
    fs_kb="$(df --output=size -k /mnt/xfs-vgextend | tail -1 | tr -d ' ')"
    fs_mib=$((fs_kb / 1024))
    echo "Filesystem visible size at /mnt/xfs-vgextend: ${fs_mib}M"
    if [ "${fs_mib}" -lt 750 ]; then
        echo "The LV grew but the filesystem doesn't reflect it yet -- run xfs_growfs against the mount point."
        ok=0
    fi
fi

[ "${ok}" -eq 1 ]
