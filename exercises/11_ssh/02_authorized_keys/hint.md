```sh
mkdir -p ~rhelings-alice/.ssh
cat /root/rhelings-11-02-staged/teammate_key.pub >> ~rhelings-alice/.ssh/authorized_keys
chown -R rhelings-alice:rhelings-alice ~rhelings-alice/.ssh
chmod 700 ~rhelings-alice/.ssh
chmod 600 ~rhelings-alice/.ssh/authorized_keys
```

The ownership/permissions matter as much as the key content -- `sshd` will
quietly refuse to use an `authorized_keys` file (or its parent directory)
that's group- or world-writable.
