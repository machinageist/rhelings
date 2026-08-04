# SELinux: semanage fcontext

A web app serves its content from `/srv/web` instead of the standard
`/var/www/html`. The policy has no opinion about `/srv/web` -- it's not a path
SELinux knows anything about, so it's currently getting some generic default
context, not `httpd_sys_content_t`.

**Task:**

1. Confirm `/srv/web/index.html` doesn't currently have `httpd_sys_content_t`.
2. Add a **persistent** file-context rule telling policy that everything under
   `/srv/web` should be `httpd_sys_content_t`.
3. Apply that rule to the files that already exist there.

Note: `restorecon` alone will not fix this. It re-applies whatever the policy
*already* says -- and right now the policy doesn't say `httpd_sys_content_t` for
this path. You have to add the rule first.
