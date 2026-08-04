# Permissions: sticky bit on a shared, world-writable directory

`/srv/scratch/` is a shared drop-box directory -- everyone needs to be able to
write files into it, so it's world-writable. Right now that also means anyone
can **delete or rename anyone else's files** in there, including ones they
don't own, which is not the intent.

**Task:**

Set the **sticky bit** on `/srv/scratch/` so that, even though it stays
world-writable, only a file's owner (or root) can delete or rename that file.

Leave the rest of the permissions as they are (`777`) -- the fix here is
specifically the sticky bit, not tightening who can write.
