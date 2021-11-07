# k8s customize deployment

## Contents
1. [RBAC 授权](#1.RBAC授权)
    - [Question](#Question)
    - [Answer](#Answer)
    - [Valid](#Valid)
2. [设置节点不可用](#set-node-unuseable) 
3. [升级节点](#update-a-node)
4. [备份etcd数据](#etcd-save-and-restore)

## 1.RBAC授权
### Question
通过命令行的方式来创建 `ClusterRole`, `ServiceAccount`以及`Rolebinding`.

### Answer  
```shell
kubectl create clusterrole processor --verb=create --resource=deployments,daemonsets,statefulsets

kubectl create serviceaccount processor -n app-team1

kubectl create rolebinding --clusterrole=processor --serviceaccount=app-team1:processor -n app-team1
```
### valid
```shell
kubectl auth can-i get deploy --as=system:serviceaccount:app-team1:processor 
```

## set node unuseable
```shell
kubectl cordon node # unscheduled
kubectl drain node --ignore-daemonsets
```

## update a node 
```shell
kubectl drain node master-1
ssh master-1
ssh -i
apt upgrade
apt install kubeadm=1.22.1-00 -y 
kubeadm upgrade plan
kubeadm upgrade apply v1.20.1 --etcd-upgrade=false # 题目要求不升级 etcd 
kubectl uncordon master-1 
apt install kubectl=1.22.1-00 kubelet=1.22.1-00 
systemctl restart kubelet
```

## etcd save and restore
### save
需要注意，在存储快照之前，需要确定证书所在的位置，
```shell
cd /etc/kubernetes/manifests/
cat kube-apiserver.yaml | grep etcd
```
输出结果如下：
```txt
    - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
    - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
    - --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
    - --etcd-servers=https://127.0.0.1:2379
```
根据证书以及题目要求，保存到相应的目录下。
```shell
ETCDCTL_API=3 etcdctl snapshot save /data/backup/etcd-snapshot.db --endpoints=https://127.0.0.1:2379  --cacert=/etc/kubernetes/pki/etcd/ca.crt --key=/etc/kubernetes/pki/apiserver-etcd-client.key --cert=/etc/kubernetes/pki/apiserver-etcd-client.crt
```
### restore
需要注意，考试的etcd是二进制部署的，因此在恢复时，需要停止服务，然后备份当前使用的目录，恢复题目要求的etcd文件，需要修改/var/lib/etcd的权限，启动服务，查看运行状态是否正常。
```shell
systemctl status etcd
systemctl stop etcd
systemctl cat etcd
mv /var/lib/default.etcd /var/lib/etcd/default.etcd.backup
ETCDCTL_API=3 etcdctl snapshot restore /data/backup/etcd-snapshot-previous.db --data-dir=/var/lib/etcd/default.etcd
chown -R etcd:etcd /var/lib/etcd
systemctl start etcd
systemctl status etcd
```