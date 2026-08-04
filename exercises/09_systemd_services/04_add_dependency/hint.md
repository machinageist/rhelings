In the `[Unit]` section, add:

```
After=network-online.target
Wants=network-online.target
```

`After=` controls ordering only; `Wants=` is what actually pulls the target
in as a dependency -- you need both. Don't forget `systemctl daemon-reload`
after editing the file, then `systemctl restart rhelings-demo`.
`systemctl list-dependencies rhelings-demo` shows the resulting tree.
