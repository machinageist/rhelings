Run as rhelings-alice so ownership and permissions come out right for free:
`su - rhelings-alice -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"`.

If you generate it as root instead, remember to `chown -R rhelings-alice:
rhelings-alice ~rhelings-alice/.ssh` and fix perms afterward (`700` on
`.ssh`, `600` on the private key).
