```sh
UID_RP=$(id -u rhelings-podman)

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman run -d --name rhelings-bind \
    -v /home/rhelings-podman/rhelings-15-02-data:/data:Z \
    docker.io/library/busybox sleep infinity

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman exec rhelings-bind \
    sh -c 'echo "bind mount works" > /data/container-wrote-this.txt'

cat /home/rhelings-podman/rhelings-15-02-data/container-wrote-this.txt
ls -Z /home/rhelings-podman/rhelings-15-02-data
```
