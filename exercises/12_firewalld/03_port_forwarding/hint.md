`firewall-cmd --permanent --add-forward-port=port=8080:proto=tcp:toport=8443`
adds the rule. `--reload` applies it. `firewall-cmd --permanent
--list-forward-ports` shows what's saved.
