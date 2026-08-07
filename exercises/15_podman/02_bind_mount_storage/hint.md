```sh
UID_RP=$(id -u rhelings-podman)

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman run -d --name rhelings-bind \
    -v /home/rhelings-podman/rhelings-15-02-data:/data:Z \
    docker.io/library/busybox sleep infinity

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman exec rhelings-bind \
    sh -c 'echo "bind mount works" > /data/container-wrote-this.txt'
```

The `:Z` suffix is the part that gets forgotten. Without it the container hits
"Permission denied" on `/data` as soon as SELinux is enforcing. Lowercase `:z`
labels the directory as shared between several containers; uppercase `:Z` labels
it private to this one.
