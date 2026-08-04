# SELinux: restorecon

`/var/www/html/index.html` was deployed by copying it from a scratch location in
a way that **preserved the source's SELinux context** instead of picking up the
correct one for its new home. The permissions are fine. The content is fine.
SELinux will still block httpd from serving it, because the *context* is wrong.

`/var/www/html` is a standard location -- the policy already knows what belongs
there. You don't need to teach it anything new here.

**Task:**

1. Check the current context of `/var/www/html/index.html` and compare it to
   what the policy expects for that path (`matchpathcon` is built for exactly
   this).
2. Fix it so the file's actual context matches the policy default.
