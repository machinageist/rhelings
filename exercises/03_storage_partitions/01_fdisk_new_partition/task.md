# Storage: partitioning with fdisk

A scratch block device has been attached to this box for you (no real second
disk required -- it's a loopback device backed by a file, but it behaves like
a real disk for partitioning purposes). Its path is stashed in
`/var/tmp/rhelings/03_storage_partitions_01_fdisk_new_partition.loopdev` --
`cat` that file to find out which device to work on. It currently has no
partition table at all.

**Task:**

Using `fdisk`, create a single primary partition of approximately **500MiB**
on that device. Accept `fdisk`'s defaults for partition number and starting
sector; you only need to control the size.

Don't forget to write the change (`fdisk` stages edits in memory until you
tell it to commit).
