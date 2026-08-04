A `.repo` file needs a bracketed section name, a `baseurl`, and `enabled=1`:

```
[vendor]
name=Vendor internal repo
baseurl=file:///opt/vendor-repo
enabled=1
gpgcheck=0
```

`dnf repolist --enabled` (or `dnf repolist all`) shows what DNF currently sees.
