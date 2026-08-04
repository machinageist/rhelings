```sh
tar -xzf /root/rhelings-lab/bundle.tar.gz -C /root/rhelings-lab/
echo "done" > /root/rhelings-lab/bundle/data/summary.txt
tar -czf /root/rhelings-lab/bundle-updated.tar.gz -C /root/rhelings-lab bundle
tar -tzf /root/rhelings-lab/bundle-updated.tar.gz
```
