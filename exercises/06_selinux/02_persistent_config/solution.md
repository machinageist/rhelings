```sh
sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config
grep '^SELINUX=' /etc/selinux/config
```
