```sh
lvcreate -n lv_app -L 300M vg_data02
mkfs.xfs /dev/mapper/vg_data02-lv_app

mkdir -p /mnt/app-data
echo "/dev/mapper/vg_data02-lv_app  /mnt/app-data  xfs  defaults  0  0" >> /etc/fstab

mount -a
findmnt /mnt/app-data
```
