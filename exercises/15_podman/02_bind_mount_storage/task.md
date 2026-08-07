# Podman: bind-mounting host storage into a container

Containers are disposable -- anything written inside one is gone when it is
removed. A bind mount maps a directory from the host into the container, so the
data lives on the host and outlives the container.

On an SELinux-enforcing system a plain bind mount looks correct and then fails
with "Permission denied" inside the container, because the host directory still
carries its own label rather than one containers are allowed to use. The `:Z`
mount option tells podman to relabel the source directory to `container_file_t`
as it mounts it.

**Task:**

As `rhelings-podman`, run a detached container named `rhelings-bind` from
`docker.io/library/busybox` running `sleep infinity`, bind-mounting the host
directory `/home/rhelings-podman/rhelings-15-02-data` at `/data` inside the
container, with SELinux relabelling enabled.

Then, from inside that container, write the line `bind mount works` into
`/data/container-wrote-this.txt`.

The file has to be readable on the host afterwards -- that is the whole point of
a bind mount.
