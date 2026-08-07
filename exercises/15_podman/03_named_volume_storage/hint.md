```sh
UID_RP=$(id -u rhelings-podman)

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman volume create rhelings-vol

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman run --name rhelings-writer -v rhelings-vol:/data \
    docker.io/library/busybox \
    sh -c 'echo "volume survived" > /data/persisted.txt'

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman rm rhelings-writer
```

Then start the reader the same way, but detached and with `sleep infinity`, so
it stays up long enough to be inspected.

Note there is no `:Z` anywhere here. Podman labels its own volumes correctly
when it creates them, so the relabel option a bind mount needed does not apply.
`podman volume inspect rhelings-vol` will show you where the data actually
landed on disk.
