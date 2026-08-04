# Swap: remove swap cleanly

`/swapfile-decom` is an active swap file that's no longer needed -- the box
it was sized for got more RAM, and ops wants it fully decommissioned rather
than just left around unused.

**Task:**

Cleanly remove this swap file:

1. Deactivate it.
2. Remove its entry from `/etc/fstab` so it doesn't try to come back on the
   next boot.
3. Delete the file itself.

All three steps matter -- stopping short of any one of them leaves either a
stale fstab entry (which would fail on the next boot once the file's gone) or
a wasted file still sitting on disk.
