# SELinux: semanage port

httpd is being reconfigured to also listen on `8081`, in addition to the normal
ports. SELinux tracks, separately from `firewalld`, which ports each daemon type
is allowed to bind -- and `8081` isn't in the list for the `http_port_t` type
yet. Until it is, httpd will fail to bind that port even if everything else
(firewall, `httpd.conf`) is correct.

**Task:**

Add TCP port `8081` to the `http_port_t` SELinux port type.

(You don't need httpd actually installed or running for this one -- just the
port-type mapping itself.)
