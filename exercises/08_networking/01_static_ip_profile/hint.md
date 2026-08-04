`nmcli connection add type dummy ifname dummy0 con-name dummy0-static
ipv4.method manual ipv4.addresses 192.0.2.10/24` creates the profile in one
shot. `nmcli connection show <name>` (or `nmcli -g ipv4.method,ipv4.addresses
connection show <name>`) lets you confirm the saved values afterward.
