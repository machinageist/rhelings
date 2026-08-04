# LVM: create a logical volume and use it

A volume group `vg_data02` already exists (backed by a scratch loopback
device) with free space in it, and no logical volumes yet.

**Task:**

1. Create a logical volume named `lv_app` in `vg_data02`, size **300MB**.
2. Format it as **XFS**.
3. Mount it persistently at `/mnt/app-data`, using its **`/dev/mapper/...`**
   path in `/etc/fstab` (not a raw `/dev/loopX` path -- LVM device paths stay
   stable in a way loop device numbers don't, which is part of the point of
   using LVM).
4. Mount it now and confirm it's active.
