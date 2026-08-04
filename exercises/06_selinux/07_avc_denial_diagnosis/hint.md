`ausearch -m avc -ts recent` shows recent denials. Look at `scontext` (what the
process was running as) and `tcontext` (what the file actually is) -- the
mismatch between them is the whole problem.

`audit2why` piped the same denial gives a plain-English explanation if the raw
`ausearch` output isn't clicking.

Once you know what type the file *should* be, the fix is the same two commands
as the `semanage_fcontext` exercise: add a persistent rule for the path, then
`restorecon -Rv` it.
