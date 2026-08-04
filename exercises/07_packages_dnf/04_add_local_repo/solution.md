```sh
cat > /etc/yum.repos.d/vendor.repo <<'EOF'
[vendor]
name=Vendor internal repo
baseurl=file:///opt/vendor-repo
enabled=1
gpgcheck=0
EOF

dnf repolist --enabled
```
