```sh
lvs vg_data03/lv_xfs01
df -h /mnt/xfs-grow

lvextend -L +200M /dev/mapper/vg_data03-lv_xfs01
xfs_growfs /mnt/xfs-grow

lvs vg_data03/lv_xfs01
df -h /mnt/xfs-grow
```
