#!/bin/bash
ETCDCTL_API=3 etcdctl snapshot save /data/backup/etcd-snapshot.db --endpoints=https://127.0.0.1:2379 --cacert=/opt/KUIN00601/ca.crt --cert=/opt/KUIN00601/etcd-client.crt --key=/opt/KUIN00601/etcd-client.key
systemctl stop etcd
systemctl cat etcd
mv /var/lib/etcd/default.etcd /var/lib/etcd/default.etcd.bak
ETCDCTL_API=3 etcdctl snapshot restore /data/backup/etcd-snapshot-privious.db --data-dir=/var/lib/etcd/default.etcd
chown -R etcd:etcd /var/lib/etcd
systemctl start etcd