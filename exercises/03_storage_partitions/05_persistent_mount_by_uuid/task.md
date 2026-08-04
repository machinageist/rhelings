# File systems: mount persistently by UUID

A scratch partition is already formatted as XFS, path stashed in
`/var/tmp/rhelings/03_storage_partitions_05_persistent_mount_by_uuid.partition`.
It needs to be mounted at `/mnt/labdata` -- and it needs to **still be
mounted after a reboot**, which means `/etc/fstab`, not a one-off `mount`
command.

**Task:**

1. Create the mount point `/mnt/labdata` if it doesn't already exist.
2. Add an entry to `/etc/fstab` that mounts the partition at `/mnt/labdata`
   persistently, identifying the filesystem **by its UUID** (not by device
   path like `/dev/loop3p1` -- loop device numbers aren't stable across
   reattachment, and on a real disk, device names like `/dev/sdb1` aren't
   guaranteed stable across reboots either, which is exactly why the exam
   cares about this).
3. Mount it now (without a reboot) and confirm it's active.
