`journalctl -u rhelings-logtest.service` shows everything journald attributed
to that unit, including subprocess output it invoked -- even a oneshot unit
that already exited leaves its log history behind.
