# Podman: running a container as a systemd service with Quadlet

The exam objective is "configure a container to start automatically as a systemd
service." There are two ways to do that, and picking the right one matters:

- `podman generate systemd` writes a `.service` file for you. It is
  **deprecated** as of podman 4.4 and **removed** in podman 5, so a lot of older
  study material still teaches a command that is on its way off current RHEL.
- **Quadlet** is the replacement, and what this exercise uses. You write a small
  declarative `.container` file and systemd generates the real service unit from
  it at daemon-reload time.

For a rootless user the Quadlet directory is `~/.config/containers/systemd/`. A
file called `NAME.container` produces a service called `NAME.service` -- the
service name comes from the *file* name, not from `ContainerName=`.

**Task:**

As `rhelings-podman`:

1. Write `~/.config/containers/systemd/rhelings-quadlet.container` describing a
   container from `docker.io/library/busybox`, named `rhelings-quadlet`,
   running `sleep infinity`, and wanted by `default.target` so it comes up at
   boot.
2. Reload the user systemd manager so the service gets generated.
3. Start `rhelings-quadlet.service`, and confirm both the service and the
   container are up.

One gotcha: `systemctl --user` driven over `sudo` needs `DBUS_SESSION_BUS_ADDRESS`
as well as `XDG_RUNTIME_DIR`, or it fails with "Failed to connect to bus":

```sh
UID_RP=$(id -u rhelings-podman)
sudo -u rhelings-podman \
    XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${UID_RP}/bus \
    systemctl --user <command>
```

Linger is already enabled for this user by the exercise setup -- without it the
user's systemd instance is torn down at logout and nothing starts at boot.
