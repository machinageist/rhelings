```sh
mapfile -t DEVS < /var/tmp/rhelings/05_lvm_01_pvcreate_vgcreate.loopdevs

pvcreate "${DEVS[0]}" "${DEVS[1]}"
vgcreate vg_data01 "${DEVS[0]}" "${DEVS[1]}"

pvs
vgs vg_data01
```
