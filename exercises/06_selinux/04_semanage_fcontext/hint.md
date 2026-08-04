Two steps, in order:

```sh
semanage fcontext -a -t httpd_sys_content_t "/srv/web(/.*)?"
restorecon -Rv /srv/web
```

`semanage fcontext -a` only edits the policy's *rulebook* -- it doesn't touch any
files on disk by itself. `restorecon` is what actually applies the rule to the
files that already exist. Skipping the second step is the most common way to
"fix" this and have it not actually work.
