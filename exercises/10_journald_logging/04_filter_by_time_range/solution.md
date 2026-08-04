```sh
cat /root/rhelings-10-04-window.txt

journalctl -t rhelings-window --since "<since from the file>" --until "<until from the file>"

echo "event inside the window" > /root/rhelings-10-04-answer.txt
```
