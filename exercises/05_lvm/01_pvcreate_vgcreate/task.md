# LVM: physical volumes and a volume group

Two scratch block devices are attached for you to build a volume group out
of. Their paths are stashed one per line in
`/var/tmp/rhelings/05_lvm_01_pvcreate_vgcreate.loopdevs` -- `cat` that file to
find them. Neither has any LVM metadata on it yet.

**Task:**

1. Initialize **both** devices as LVM physical volumes.
2. Create a volume group named `vg_data01` that includes **both** physical
   volumes.

This is the foundation everything else in LVM builds on: PVs are the raw
building blocks, a VG pools them into one flexible chunk of storage that
logical volumes get carved out of later.
