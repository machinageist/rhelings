# systemd: unit dependencies

`rhelings-demo.service` currently has no explicit ordering or dependency
relationship with networking -- it's whatever the default is. That's a
problem, because in a real version of this service, starting before the
network is up would make it fail.

**Task:**

1. Edit `/etc/systemd/system/rhelings-demo.service` so the unit both waits
   for and requires `network-online.target` (i.e. add it to `After=` and
   `Wants=` in the `[Unit]` section).
2. Reload systemd's unit definitions and restart the service to pick up the
   change.
3. Use `systemctl list-dependencies rhelings-demo` to confirm
   `network-online.target` now shows up in its dependency tree.
