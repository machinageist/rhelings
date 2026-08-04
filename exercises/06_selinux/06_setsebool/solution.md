```sh
getsebool httpd_can_network_connect
setsebool -P httpd_can_network_connect on
semanage boolean -l | grep httpd_can_network_connect
```
