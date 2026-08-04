`hostnamectl set-hostname rhcsa-lab.example.com` sets the persistent static
hostname (backed by `/etc/hostname`) and applies it immediately -- no reboot
needed. `hostnamectl --static` (or plain `hostnamectl`) confirms it.
