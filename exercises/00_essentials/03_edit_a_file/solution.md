Using a heredoc from the shell is the fastest way to get exact content, but on
the real exam you'll do this by hand in `vi` or `nano`:

```sh
cat > /root/rhelings-lab/motd-lab.txt <<'EOF'
Authorized access only.
All activity is logged.
Contact: labadmin@example.com
EOF
```

In `vi`: `vi /root/rhelings-lab/motd-lab.txt`, `gg` to the top, `dG` to delete
everything, `i` to insert, type the three lines, `Esc`, `:wq`.
