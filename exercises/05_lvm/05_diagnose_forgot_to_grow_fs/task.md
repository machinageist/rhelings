# LVM: diagnose a resize that didn't actually resize anything

A colleague says they already extended `lv_gotcha` in `vg_data05` (mounted at
`/mnt/xfs-gotcha`, formatted XFS) to fix a low-space alert. The alert is still
firing. `df -h /mnt/xfs-gotcha` shows the same size it's always shown.

**Task:**

1. Check `lvs vg_data05/lv_gotcha` and compare it against what `df` reports
   for `/mnt/xfs-gotcha`. Figure out which layer actually got resized and
   which one didn't.
2. Fix the mismatch -- without running `lvextend` again. The LV is already
   the right size; something else is missing.

If you're not sure which resize tool applies here, `blkid` or `mount` will
tell you the filesystem type, which tells you which tool you need.
