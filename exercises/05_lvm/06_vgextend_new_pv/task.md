# LVM: extend a volume group with a new PV, then extend the LV

Volume group `vg_data06` has a single physical volume in it, almost entirely
consumed by the logical volume `lv_grow` (mounted at `/mnt/xfs-vgextend`,
formatted XFS). There's no free space left in the VG to extend into --
`lvextend` alone can't help here, because the VG itself is out of room.

A second scratch block device is available but **not yet part of any volume
group**. Its path is stashed in
`/var/tmp/rhelings/05_lvm_06_vgextend_new_pv.newdev`.

**Task:**

1. Initialize the new device as a PV and add it to `vg_data06` -- this is the
   step that actually creates new free space to work with.
2. Extend `lv_grow` to use **all** of the VG's newly-available free space
   (don't guess a specific size -- there's a way to tell `lvextend` to just
   take everything free).
3. Grow the XFS filesystem to match.
