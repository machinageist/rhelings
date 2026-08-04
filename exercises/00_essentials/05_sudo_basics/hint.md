Never edit `/etc/sudoers` directly with a plain text editor -- `visudo` (or a
drop-in file under `/etc/sudoers.d/`) syntax-checks before saving, so one typo
can't lock everyone out of sudo.

Create `/etc/sudoers.d/labtech` with a line shaped like:

```
labtech ALL=(root) NOPASSWD: /usr/bin/systemctl status sshd
```

Then validate everything under `/etc/sudoers.d/` at once with `visudo -c`.

`sudo -l -U labtech` shows exactly what labtech is currently allowed to run --
use it to confirm the grant actually took effect, not just that the file looks
right.
