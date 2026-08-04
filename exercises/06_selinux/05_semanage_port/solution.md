```sh
semanage port -l | grep http_port_t
semanage port -a -t http_port_t -p tcp 8081
semanage port -l | grep http_port_t
```
