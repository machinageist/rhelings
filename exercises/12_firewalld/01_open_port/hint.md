`firewall-cmd --permanent --add-port=8443/tcp` edits the permanent config
only -- it doesn't apply to the currently running firewall until you
`firewall-cmd --reload` (or add `--zone=` if you're not targeting the
default zone). `firewall-cmd --permanent --list-ports` shows what's saved.
