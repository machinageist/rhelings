The unit file, at
`/home/rhelings-podman/.config/containers/systemd/rhelings-quadlet.container`:

```ini
[Unit]
Description=rhelings Quadlet demo container

[Container]
Image=docker.io/library/busybox
ContainerName=rhelings-quadlet
Exec=sleep infinity

[Install]
WantedBy=default.target
```

Then reload and start it:

```sh
UID_RP=$(id -u rhelings-podman)

sudo -u rhelings-podman \
    XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${UID_RP}/bus \
    systemctl --user daemon-reload

sudo -u rhelings-podman \
    XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${UID_RP}/bus \
    systemctl --user start rhelings-quadlet.service
```

Do not reach for `systemctl --user enable rhelings-quadlet.service` -- generated
units cannot be enabled that way, and it will fail. The
`[Install] WantedBy=default.target` line in the `.container` file is what makes
it start at boot.

Make sure the file is owned by `rhelings-podman`, not root -- if you wrote it
with a plain `sudo tee`, `chown` it.
