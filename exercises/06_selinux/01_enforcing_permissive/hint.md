`getenforce` prints the current runtime mode.

`setenforce 0` switches to Permissive without a reboot; `setenforce 1` switches
back to Enforcing. Neither one touches `/etc/selinux/config`.
