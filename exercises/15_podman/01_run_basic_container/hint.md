```sh
UID_RP=$(id -u rhelings-podman)
sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} \
    podman run -d --name rhelings-demo docker.io/library/busybox sleep infinity

sudo -u rhelings-podman XDG_RUNTIME_DIR=/run/user/${UID_RP} podman ps
```

If `podman` complains about a missing runtime directory, the user's systemd
instance may not have started yet -- `setup.sh` already handles that, so try
resetting the exercise (`r`).
