# LVM: extend a logical volume and grow ext4

`lv_ext401` in volume group `vg_data04` is mounted at `/mnt/ext4-grow` and
formatted **ext4** -- same situation as the XFS exercise, different
filesystem, and a genuinely different tool for the second step.

**Task:**

1. Extend `lv_ext401` by **200MB**.
2. Grow the ext4 filesystem on it to actually use the new space.

For ext4, the resize tool is `resize2fs`, not `xfs_growfs` -- and unlike
`xfs_growfs`, `resize2fs` takes the **device path**, not the mount point.
`resize2fs` can also grow ext4 offline (unmounted) if needed, though growing
it online while mounted works fine too, which is what you'll do here since
it's already mounted.

Mixing these two up -- `xfs_growfs` on an ext4 device, or `resize2fs` on an
XFS one -- is a real, easy-to-make mistake on the exam. They're not
interchangeable; each only understands its own filesystem's on-disk format.
