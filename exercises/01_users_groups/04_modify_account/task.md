# Users & Groups: modify an existing account

`svcmon` is an existing service account. It was created with a login shell and
a home directory under `/home/`, but it should never actually be used for
interactive login, and its data needs to live under `/srv/` with the rest of
the service accounts on this box.

**Task:**

1. Change `svcmon`'s login shell to `/sbin/nologin`.
2. Move `svcmon`'s home directory from `/home/svcmon` to `/srv/svcmon`,
   **moving the existing contents** (there's a file in there) rather than
   just repointing the account at an empty directory.
