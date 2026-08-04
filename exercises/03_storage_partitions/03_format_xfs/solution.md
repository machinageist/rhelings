```sh
PART="$(cat /var/tmp/rhelings/03_storage_partitions_03_format_xfs.partition)"
mkfs.xfs -L LABDATA1 "${PART}"
blkid "${PART}"
```
