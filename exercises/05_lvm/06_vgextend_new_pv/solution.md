```sh
NEWDEV="$(cat /var/tmp/rhelings/05_lvm_06_vgextend_new_pv.newdev)"

pvcreate "${NEWDEV}"
vgextend vg_data06 "${NEWDEV}"
vgs vg_data06

lvextend -l +100%FREE /dev/mapper/vg_data06-lv_grow
xfs_growfs /mnt/xfs-vgextend

lvs vg_data06/lv_grow
df -h /mnt/xfs-vgextend
```
