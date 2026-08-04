```sh
matchpathcon -V /srv/web/index.html
semanage fcontext -a -t httpd_sys_content_t "/srv/web(/.*)?"
restorecon -Rv /srv/web
matchpathcon -V /srv/web/index.html
```
