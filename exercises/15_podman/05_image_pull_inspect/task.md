# Podman: retrieving and inspecting an image

Before you run anything you have to fetch an image and know what is inside it.
The exam objectives call these out separately from running containers: "find and
retrieve container images from a remote registry" and "inspect container images."

Inspecting matters because an image tells you how it expects to be run -- most
usefully, which port the service inside it listens on. Getting that wrong is the
usual reason a published-port container starts cleanly and then serves nothing.

**Task:**

As `rhelings-podman`:

1. Pull `docker.io/library/httpd:2.4`.
2. Inspect the image and find the port it declares as exposed.
3. Write just that port number -- digits only, no `/tcp` -- into
   `/home/rhelings-podman/rhelings-15-05-exposed-port.txt`.

`podman image inspect` prints a large JSON document. The `--format` flag with a
Go template is how you pull a single field out of it without scrolling, but it
is worth reading the whole document once to see what an image actually carries.

You will reuse this image in the next exercise, so leave it in place.
