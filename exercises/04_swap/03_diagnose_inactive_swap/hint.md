`swapon -a` tries to activate everything listed in `/etc/fstab` and will tell
you exactly which line failed and why -- usually "No such file or directory"
if the path is wrong.

`cat /etc/fstab | grep swap` shows what path it's currently trying to use.
`ls -l /swapfile*` shows what actually exists on disk. Compare the two.

The fix is a one-character-off filename in `/etc/fstab` -- correct the path
in the existing line to match the real file, don't add a second line.
