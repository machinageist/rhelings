`usermod -s /sbin/nologin svcmon` changes just the shell.

`usermod -d /srv/svcmon svcmon` changes where the account's home directory
*points to* in `/etc/passwd`, but does **not** touch anything on disk by
itself -- add `-m` to also move the actual directory contents from the old
home to the new one:

```sh
usermod -d /srv/svcmon -m svcmon
```

Both changes can be done in one `usermod` call or two separate ones -- either
is fine.
