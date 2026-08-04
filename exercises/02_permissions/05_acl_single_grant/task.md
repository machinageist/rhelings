# Permissions: a one-off grant with an ACL

`/root/rhelings-lab/finance/budget.csv` is owned by `root:root`, mode `640`
(owner rw, group r, others nothing). The user `auditor` needs **read access**
to this one file for a compliance review -- but `auditor` isn't in the file's
group, and changing the group or the standard permission bits would open
access up more broadly than "just this one user, read-only."

**Task:**

Grant the user `auditor` read (`r--`) access to
`/root/rhelings-lab/finance/budget.csv` using a POSIX ACL, without changing
the file's existing owner, group, or standard permission bits.
