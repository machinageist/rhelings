`semanage port -l | grep http_port_t` shows what's currently allowed.

`semanage port -a -t http_port_t -p tcp 8081` adds the new port. Use `-m`
instead of `-a` if you're modifying a port that's already assigned to some
*other* type.
