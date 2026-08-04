# Permissions: default ACLs for inheritance

`/srv/shared/incoming/` is a directory where several apps drop files
throughout the day. The `reviewer` user needs read access to **every file
that ends up in there**, including ones that don't exist yet -- reviewer
wasn't around when the directory was created, and re-running `setfacl` by
hand every time a new file shows up isn't sustainable.

**Task:**

1. Grant `reviewer` read (`r--`) access to `/srv/shared/incoming/` itself via
   an ACL.
2. Set a **default ACL** on the directory so that any new file created inside
   it afterward automatically gets that same `reviewer:r--` grant, with no
   further `setfacl` calls needed per file.

Verify by creating a new file in the directory after setting the default ACL,
and confirming `reviewer`'s access shows up on it automatically.
