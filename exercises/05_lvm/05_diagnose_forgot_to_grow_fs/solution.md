```sh
lvs vg_data05/lv_gotcha
df -h /mnt/xfs-gotcha
mount | grep xfs-gotcha   # confirms fstype=xfs, so xfs_growfs is the right tool

xfs_growfs /mnt/xfs-gotcha

df -h /mnt/xfs-gotcha
```
