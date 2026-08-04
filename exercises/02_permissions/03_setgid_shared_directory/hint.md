`chgrp launchteam /srv/projects/launch` fixes the group ownership.

Setgid on a directory is the `2` in a 4-digit octal mode, or `g+s`
symbolically:

```sh
chmod g+s /srv/projects/launch
# or, setting the full mode explicitly:
chmod 2775 /srv/projects/launch
```

`ls -ld` shows an `s` in the group execute position (`rwxrwsr-x`) when it's
set. Confirm it actually works, not just that the bit looks right, by
`touch`ing a new file inside and checking its group with `stat -c '%G'`.
