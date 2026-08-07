```sh
UID_RP=$(id -u rhelings-podman)

echo "Welcome to the rhelings container web server" | \
    sudo -u rhelings-podman tee /home/rhelings-podman/rhelings-15-06-web/index.html

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman run -d --name rhelings-web \
    -p 8080:80 \
    -v /home/rhelings-podman/rhelings-15-06-web:/usr/local/apache2/htdocs:Z \
    docker.io/library/httpd:2.4

curl http://localhost:8080/
```

`-p` reads *host*:*container*. Writing it backwards is the classic mistake, and
as a rootless user `-p 80:8080` fails outright rather than silently doing the
wrong thing -- binding host port 80 is not allowed.

`podman port rhelings-web` shows what actually got published, which is the first
thing to check when a request is refused.
