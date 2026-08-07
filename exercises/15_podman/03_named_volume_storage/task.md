# Podman: persistent storage with a named volume

A bind mount (previous exercise) points at a directory you create and manage
yourself. A *named volume* is storage podman creates and tracks for you -- you
refer to it by name and never have to care where on disk it actually lives. It
is the usual choice when the data belongs to the application rather than to the
host.

The point here is to prove the data really is independent of any one container:
you will write from one container, destroy that container, then read the data
back from a different one.

**Task:**

As `rhelings-podman`:

1. Create a named volume called `rhelings-vol`.
2. Run a container named `rhelings-writer` from `docker.io/library/busybox`
   with `rhelings-vol` mounted at `/data`, writing the line `volume survived`
   into `/data/persisted.txt`.
3. Remove the `rhelings-writer` container completely.
4. Run a second detached container named `rhelings-reader`, also from busybox,
   with the same volume mounted at `/data`, running `sleep infinity`.

The check reads `/data/persisted.txt` back out of `rhelings-reader`, and fails
if `rhelings-writer` still exists -- otherwise nothing has been proven.
