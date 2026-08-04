`useradd` creates a user and, by default, its home directory. The flag to pin
a specific UID instead of letting the system pick the next free one is `-u`.

```sh
useradd -u 5010 jsmith
```
