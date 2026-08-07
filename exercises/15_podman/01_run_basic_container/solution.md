```sh
UID_RP=$(id -u rhelings-podman)

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman run -d --name rhelings-demo docker.io/library/busybox sleep infinity

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} podman ps
```
