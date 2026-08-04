`getsebool httpd_can_network_connect` shows the current value.
`semanage boolean -l | grep httpd_can_network_connect` shows both the current
value AND the persisted (boot-time) default, as `(current, persisted)`.

`setsebool -P httpd_can_network_connect on` sets both at once. Without `-P` you
only change the current value, and it reverts on reboot.
