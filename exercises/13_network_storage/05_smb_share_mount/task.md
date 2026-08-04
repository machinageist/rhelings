# Network storage: mounting an SMB/CIFS share

Like the NFS exercises, this box runs both the Samba server and the client
side against itself over `127.0.0.1`, so the whole thing is practiceable on
one machine. On the real exam you'd typically be pointed at a share that
already exists on another server.

A Samba share named `rhelingsshare` is already configured and serving
`/srv/sambashare`, for the local user `rhelings-smb` (password
`rhelings-smb-pass123` -- a throwaway lab credential, not a real secret).

**Task:**

1. Create a credentials file at `/root/.rhelings-13-05-credentials` (mode
   `600` -- it contains a password) with:
   ```
   username=rhelings-smb
   password=rhelings-smb-pass123
   ```
2. Mount `//127.0.0.1/rhelingsshare` at `/mnt/smbclient` using that
   credentials file (`-o credentials=...`), rather than putting the password
   directly on the command line.
