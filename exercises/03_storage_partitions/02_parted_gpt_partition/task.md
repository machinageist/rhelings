# Storage: GPT partitioning with parted

A second scratch block device is attached, path stashed in
`/var/tmp/rhelings/03_storage_partitions_02_parted_gpt_partition.loopdev`.
Unlike the previous exercise, this device has **no partition table at all
yet** -- not even an empty one. `fdisk` defaults to an old-style MBR
(`msdos`) partition table; for a modern GPT layout you need `parted`.

**Task:**

Using `parted`, on the scratch device:

1. Create a **GPT** partition table.
2. Create a single partition spanning (approximately) the whole disk.

`parted` can be driven non-interactively with `-s` and a list of commands, or
used interactively -- either is fine, as long as the end state is right.
