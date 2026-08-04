`nmcli connection modify dummy1-manual ipv4.dns "198.51.100.1 198.51.100.2"`
sets both servers at once (space-separated, in quotes). `nmcli -g ipv4.dns
connection show dummy1-manual` confirms what's saved.
