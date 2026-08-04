#!/usr/bin/env bash
# Idempotent: installs Samba, creates the share directory and content, sets
# up the rhelings-smb user and Samba password, defines the [rhelingsshare]
# share, applies the correct SELinux context so the exercise stays focused on
# CIFS mounting rather than SELinux troubleshooting, starts smb/nmb, and
# makes sure /mnt/smbclient starts out unmounted with no stale credentials
# file left over.
set -euo pipefail

dnf install -y samba samba-client cifs-utils >/dev/null 2>&1 || true

mkdir -p /srv/sambashare
echo "smb share test content" > /srv/sambashare/hello.txt

id rhelings-smb >/dev/null 2>&1 || useradd -M -s /sbin/nologin rhelings-smb
printf 'rhelings-smb-pass123\nrhelings-smb-pass123\n' | smbpasswd -a -s rhelings-smb >/dev/null 2>&1 || true
smbpasswd -e rhelings-smb >/dev/null 2>&1 || true

if ! grep -q '\[rhelingsshare\]' /etc/samba/smb.conf 2>/dev/null; then
    cat >> /etc/samba/smb.conf <<'EOF'

[rhelingsshare]
    path = /srv/sambashare
    valid users = rhelings-smb
    read only = no
EOF
fi

if command -v semanage >/dev/null 2>&1; then
    semanage fcontext -a -t samba_share_t "/srv/sambashare(/.*)?" 2>/dev/null || true
    restorecon -Rv /srv/sambashare >/dev/null 2>&1 || true
fi

systemctl enable --now smb nmb >/dev/null 2>&1 || true

mkdir -p /mnt/smbclient
mountpoint -q /mnt/smbclient && umount /mnt/smbclient || true

rm -f /root/.rhelings-13-05-credentials
