`userdel tmpcontractor` alone removes the account but leaves `/home/tmpcontractor`
sitting on disk.

`userdel -r tmpcontractor` also removes the home directory and mail spool.
That `-r` is the whole difference between "disable the account" and "actually
clean up after it."
