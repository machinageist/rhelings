Find the partition and its UUID:

```sh
PART="$(cat /var/tmp/rhelings/03_storage_partitions_05_persistent_mount_by_uuid.partition)"
blkid "${PART}"
```

An `/etc/fstab` line has six whitespace-separated fields:
`<device> <mountpoint> <fstype> <options> <dump> <pass>`. Use the UUID form
for the first field instead of the raw device path:

```
UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx  /mnt/labdata  xfs  defaults  0  0
```

After editing `/etc/fstab`, `mount -a` mounts everything in it that isn't
already mounted -- and importantly, it will loudly fail if you got a line
wrong, which is a much safer way to test an fstab edit than just rebooting
and hoping.
