# Podman: running a rootless container

`rhelings-podman` is a regular, non-root local user on this box (rootless
containers run as a normal user -- that's the whole point of "rootless").
Everything in this domain runs as that user, not as root, even though
`rhelings` itself needs root to drive its checks.

**Task:**

As `rhelings-podman`, pull `docker.io/library/busybox` and run it detached,
named `rhelings-demo`, executing `sleep infinity` so it stays up. Confirm
it's running.

To act as `rhelings-podman` for a rootless podman command, run something
like:

```sh
sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/$(id -u rhelings-podman) podman <command>
```
