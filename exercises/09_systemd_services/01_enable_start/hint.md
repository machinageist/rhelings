`systemctl enable --now rhelings-demo` does both at once -- enables it for
boot and starts it immediately. `systemctl status rhelings-demo` (or
`systemctl is-active` / `is-enabled`) confirms each piece separately.
