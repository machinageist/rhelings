`chown` sets the owning user, and can set the group at the same time with
`user:group`. `-R` makes it recursive.

```sh
chown -R appsvc:appteam /root/rhelings-lab/deploy
```

`chgrp -R appteam /root/rhelings-lab/deploy` alone would only fix the group,
leaving root as the owner -- you need both changed here.
