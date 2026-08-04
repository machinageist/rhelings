Find your devices:

```sh
cat /var/tmp/rhelings/05_lvm_01_pvcreate_vgcreate.loopdevs
```

`pvcreate` takes one or more device paths at once:

```sh
pvcreate /dev/loopX /dev/loopY
```

`vgcreate NAME DEVICE [DEVICE...]` creates a volume group from one or more
already-initialized PVs:

```sh
vgcreate vg_data01 /dev/loopX /dev/loopY
```

`pvs` and `vgs` show what currently exists at each layer -- useful for
sanity-checking before moving on.
