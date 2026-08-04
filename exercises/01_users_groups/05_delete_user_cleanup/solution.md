```sh
userdel -r tmpcontractor
id tmpcontractor       # should report "no such user"
ls /home/tmpcontractor # should report "No such file or directory"
```
