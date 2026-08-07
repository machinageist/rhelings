```sh
UID_RP=$(id -u rhelings-podman)

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman pull docker.io/library/httpd:2.4

# The whole document, to see what an image carries:
sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman image inspect docker.io/library/httpd:2.4

# Just the exposed ports -- prints: map[80/tcp:{}]
sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman image inspect docker.io/library/httpd:2.4 \
    --format '{{.Config.ExposedPorts}}'

echo 80 | sudo -u rhelings-podman tee \
    /home/rhelings-podman/rhelings-15-05-exposed-port.txt
```
