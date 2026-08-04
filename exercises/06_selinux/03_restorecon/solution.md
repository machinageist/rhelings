```sh
matchpathcon -V /var/www/html/index.html
restorecon -Rv /var/www/html
matchpathcon -V /var/www/html/index.html
```
