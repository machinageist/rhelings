`matchpathcon -V /var/www/html/index.html` tells you directly whether the file's
current context matches what policy expects for that path.

`restorecon -Rv /var/www/html` re-applies the policy's default context to
everything under that path. No `semanage` needed -- the default is already
defined for this standard location.
