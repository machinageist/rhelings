```sh
UID_RP=$(id -u rhelings-podman)

sudo -u rhelings-podman mkdir -p /home/rhelings-podman/.config/containers/systemd

sudo -u rhelings-podman tee \
    /home/rhelings-podman/.config/containers/systemd/rhelings-quadlet.container \
    >/dev/null <<'EOF'
[Unit]
Description=rhelings Quadlet demo container

[Container]
Image=docker.io/library/busybox
ContainerName=rhelings-quadlet
Exec=sleep infinity

[Install]
WantedBy=default.target
EOF

sudo -u rhelings-podman \
    XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${UID_RP}/bus \
    systemctl --user daemon-reload

sudo -u rhelings-podman \
    XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${UID_RP}/bus \
    systemctl --user start rhelings-quadlet.service

sudo -u rhelings-podman \
    XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${UID_RP}/bus \
    systemctl --user status rhelings-quadlet.service

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} podman ps
```
