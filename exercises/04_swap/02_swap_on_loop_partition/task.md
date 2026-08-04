# Swap: create swap on a partition

A scratch block device with a single partition already on it is attached; the
partition's path is stashed in
`/var/tmp/rhelings/04_swap_02_swap_on_loop_partition.partition`. It isn't
formatted with anything yet.

**Task:**

1. Initialize that partition as swap space.
2. Activate it.
3. Make it activate automatically on every boot via `/etc/fstab`, identifying
   it **by UUID** rather than by device path.
