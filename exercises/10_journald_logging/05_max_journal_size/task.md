# journald: capping journal disk usage

Nothing on this box currently limits how large the persistent journal is
allowed to grow. That's a real problem on a long-lived server -- an unbounded
journal can eventually fill `/var`.

**Task:**

Configure journald to cap total on-disk journal usage at 50 megabytes,
**persistently** (via `journald.conf`, not a one-off `--vacuum-size` trim
that only cleans up what's already there right now).
