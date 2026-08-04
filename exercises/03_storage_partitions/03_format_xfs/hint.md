Find your partition:

```sh
cat /var/tmp/rhelings/03_storage_partitions_03_format_xfs.partition
```

`mkfs.xfs -L LABEL DEVICE` creates an XFS filesystem with a label in one
step. XFS labels are capped at 12 characters -- `LABDATA1` fits comfortably.

`blkid DEVICE` shows the resulting `TYPE=` and `LABEL=` once it's formatted.
