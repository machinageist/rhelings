```sh
ausearch -m avc -ts recent
# or, if that comes up empty:
journalctl -t setroubleshoot --since "10 min ago"

semanage fcontext -a -t httpd_sys_content_t "/srv/appdata(/.*)?"
restorecon -Rv /srv/appdata
matchpathcon -V /srv/appdata/data.txt
```
