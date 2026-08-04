```sh
PART="$(cat /var/tmp/rhelings/03_storage_partitions_05_persistent_mount_by_uuid.partition)"
UUID="$(blkid -s UUID -o value "${PART}")"

mkdir -p /mnt/labdata
echo "UUID=${UUID}  /mnt/labdata  xfs  defaults  0  0" >> /etc/fstab

mount -a
findmnt /mnt/labdata
```
