# LVM: extend a logical volume and grow XFS

`lv_xfs01` in volume group `vg_data03` is mounted at `/mnt/xfs-grow` and
formatted **XFS**. It's running low on space and `vg_data03` has free extents
available.

**Task:**

1. Extend `lv_xfs01` by **200MB**.
2. Grow the XFS filesystem on it to actually use the new space.

This is two separate layers, and it's a common way to half-finish this task
on the exam: `lvextend` only resizes the block device the logical volume
presents -- it does **not** touch the filesystem sitting on top of it. Until
you also grow the filesystem, `df` will still report the old, smaller size
even though `lvs` shows the LV as bigger.

For XFS specifically, the tool that grows the filesystem is `xfs_growfs`,
and it works **online** -- run it against the mount point, with the
filesystem still mounted, not the device.
