`setfacl -m u:auditor:r FILE` adds a named-user ACL entry granting exactly the
permissions you specify, on top of (not instead of) the standard owner/group/
other bits.

```sh
setfacl -m u:auditor:r /root/rhelings-lab/finance/budget.csv
```

`getfacl FILE` shows the full ACL, including the standard permissions and any
extra entries. A file with a non-default ACL also shows a trailing `+` in
`ls -l` output -- a quick visual signal something extra is going on.
