# SELinux: diagnosing an AVC denial

A small internal app reads its data from `/srv/appdata`. Something has already
tried to read it once and been denied by SELinux -- there should be a real
denial sitting in the audit log right now.

**Task:**

1. Find the denial. `ausearch -m avc -ts recent` is the direct tool; if auditd
   isn't logging to `/var/log/audit/audit.log` for some reason, `journalctl` can
   surface the same event.
2. Read it. The denial tells you what type the process expected
   (`scontext`/`tcontext`) versus what the file actually has.
3. Fix the root cause -- don't just silence the denial. Treat `/srv/appdata` the
   same way you'd treat any non-standard content path: it needs a real,
   persistent policy rule, not a one-off relabel.

This is the same underlying fix as the `semanage fcontext` exercise. The
difference here is you have to find the problem yourself instead of being told
what's wrong.
