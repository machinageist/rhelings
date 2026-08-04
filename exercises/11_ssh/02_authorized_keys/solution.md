```sh
mkdir -p /home/rhelings-alice/.ssh
cat /root/rhelings-11-02-staged/teammate_key.pub >> /home/rhelings-alice/.ssh/authorized_keys
chown -R rhelings-alice:rhelings-alice /home/rhelings-alice/.ssh
chmod 700 /home/rhelings-alice/.ssh
chmod 600 /home/rhelings-alice/.ssh/authorized_keys
```
