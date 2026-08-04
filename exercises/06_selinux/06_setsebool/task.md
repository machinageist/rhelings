# SELinux: booleans

httpd needs to make outbound network connections -- for example, to reach a
database on another host. By default, the `httpd_can_network_connect` boolean
is off, which blocks that regardless of firewall rules.

**Task:**

Turn `httpd_can_network_connect` on, **persistently** (it needs to survive a
reboot, not just apply to the current boot).
