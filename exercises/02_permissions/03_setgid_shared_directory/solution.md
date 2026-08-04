```sh
chgrp launchteam /srv/projects/launch
chmod 2775 /srv/projects/launch
ls -ld /srv/projects/launch

# verify inheritance
touch /srv/projects/launch/test.txt
stat -c '%G' /srv/projects/launch/test.txt   # should print launchteam
rm /srv/projects/launch/test.txt
```
