```sh
chmod 750 /root/rhelings-lab/secrets
chmod 640 /root/rhelings-lab/secrets/db.env
chmod 750 /root/rhelings-lab/secrets/rotate.sh
stat -c '%a %n' /root/rhelings-lab/secrets /root/rhelings-lab/secrets/db.env /root/rhelings-lab/secrets/rotate.sh
```
