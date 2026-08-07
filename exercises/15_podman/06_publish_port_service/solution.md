```sh
UID_RP=$(id -u rhelings-podman)

echo "Welcome to the rhelings container web server" | \
    sudo -u rhelings-podman tee /home/rhelings-podman/rhelings-15-06-web/index.html

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman run -d --name rhelings-web \
    -p 8080:80 \
    -v /home/rhelings-podman/rhelings-15-06-web:/usr/local/apache2/htdocs:Z \
    docker.io/library/httpd:2.4

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman port rhelings-web

curl http://localhost:8080/
```
