Octal `chmod` sets all three permission groups (owner/group/other) at once as
a three-digit number, e.g. `750` = owner `7` (rwx), group `5` (r-x), other `0`
(---).

```sh
chmod 750 /root/rhelings-lab/secrets
chmod 640 /root/rhelings-lab/secrets/db.env
chmod 750 /root/rhelings-lab/secrets/rotate.sh
```

`stat -c '%a' path` prints a file's current mode as octal, useful for
double-checking before and after.
