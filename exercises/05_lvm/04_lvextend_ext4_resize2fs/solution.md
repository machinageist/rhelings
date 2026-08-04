```sh
lvs vg_data04/lv_ext401
df -h /mnt/ext4-grow

lvextend -L +200M /dev/mapper/vg_data04-lv_ext401
resize2fs /dev/mapper/vg_data04-lv_ext401

lvs vg_data04/lv_ext401
df -h /mnt/ext4-grow
```
