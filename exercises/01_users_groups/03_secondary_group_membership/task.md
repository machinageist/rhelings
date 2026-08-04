# Users & Groups: add a user to a secondary group

`dbryant` is an existing user with their own private primary group (the
default `useradd` behavior). They now need access to shared resources owned by
the `opsteam` group -- but only *in addition to* their existing group, not
instead of it.

**Task:**

Add `dbryant` to the `opsteam` group as a **secondary** group, without
changing their primary group and without removing them from any other
secondary group they might already be in.
