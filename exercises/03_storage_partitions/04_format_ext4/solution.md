```sh
PART="$(cat /var/tmp/rhelings/03_storage_partitions_04_format_ext4.partition)"
mkfs.ext4 -L LABDATA2 "${PART}"
blkid "${PART}"
```
