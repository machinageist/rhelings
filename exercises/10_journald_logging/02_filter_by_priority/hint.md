`journalctl -t rhelings-batch` filters by syslog identifier. Add `-p err` to
filter by priority -- a single value shows that priority and anything more
urgent (there's nothing more urgent logged here, so you'll get just the one
line). Combine both: `journalctl -t rhelings-batch -p err`.
