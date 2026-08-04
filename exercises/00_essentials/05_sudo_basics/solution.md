```sh
echo 'labtech ALL=(root) NOPASSWD: /usr/bin/systemctl status sshd' > /etc/sudoers.d/labtech
chmod 440 /etc/sudoers.d/labtech
visudo -c
sudo -l -U labtech
```
