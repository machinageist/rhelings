Two separate `setfacl` calls -- a regular grant and a default grant, they
don't imply each other:

```sh
setfacl -m u:reviewer:r /srv/shared/incoming
setfacl -d -m u:reviewer:r /srv/shared/incoming
```

`-d` sets the ACL in the directory's **default** ACL, which is what gets
copied onto new files/directories created inside it afterward -- it does
nothing for files that already exist there. The first command (no `-d`)
covers access to the directory itself right now; the second covers everything
created inside it from now on.

`getfacl` on a new file created inside the directory should show the
inherited `user:reviewer:r--` entry without you having run `setfacl` on that
file directly.
