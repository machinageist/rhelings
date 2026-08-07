```sh
UID_RP=$(id -u rhelings-podman)

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman pull docker.io/library/httpd:2.4

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman image inspect docker.io/library/httpd:2.4 \
    --format '{{.Config.ExposedPorts}}'
```

That last command prints something shaped like `map[NNN/tcp:{}]`. The answer
file wants only the `NNN` part.

Run the inspect without `--format` at least once and read the raw JSON -- the
`ExposedPorts`, `Env`, `Cmd`, and `Entrypoint` keys are the ones that tell you
how the image expects to be run.
