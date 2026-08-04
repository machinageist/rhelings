```sh
setfacl -m u:reviewer:r /srv/shared/incoming
setfacl -d -m u:reviewer:r /srv/shared/incoming
getfacl /srv/shared/incoming

# verify inheritance
touch /srv/shared/incoming/new-report.txt
getfacl /srv/shared/incoming/new-report.txt   # should show user:reviewer:r--
rm /srv/shared/incoming/new-report.txt
```
