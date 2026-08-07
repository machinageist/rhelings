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

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman run -d --name rhelings-reader -v rhelings-vol:/data \
    docker.io/library/busybox sleep infinity

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman exec rhelings-reader cat /data/persisted.txt

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman volume inspect rhelings-vol
```
