# Podman: publishing a port and serving content

Running a container is not much use if nothing can reach it. Publishing a port
maps a port on the host to a port inside the container, so traffic arriving at
the host gets forwarded in.

Two things that matter for rootless containers:

- A rootless container **cannot bind host ports below 1024**. That is a kernel
  restriction on unprivileged processes, not a podman one, and it is why this
  exercise uses 8080 rather than 80.
- The port the service listens on *inside* the container comes from the image,
  not from you. You found it in the previous exercise:
  `docker.io/library/httpd:2.4` exposes port 80.

**Task:**

As `rhelings-podman`:

1. Write an `index.html` into `/home/rhelings-podman/rhelings-15-06-web/`
   containing the line `Welcome to the rhelings container web server`.
2. Run a detached container named `rhelings-web` from
   `docker.io/library/httpd:2.4` that publishes host port `8080` to the
   container's port `80`, and bind-mounts that directory at
   `/usr/local/apache2/htdocs` -- the document root this image serves from --
   with SELinux relabelling.
3. Confirm `curl http://localhost:8080/` returns your page.

Note what is deliberately *not* needed here: a firewalld rule. The check
requests the page from the host itself, and loopback traffic never crosses a
zone. For another machine to reach this you would also need
`firewall-cmd --add-port=8080/tcp --permanent` -- see the firewalld exercises.
