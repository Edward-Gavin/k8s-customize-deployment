#!/bin/bash
kubectl drain mk8s-master-0 --ignore-daemonsets
ssh mk8s-master-0
ssh -i
apt install kubeadm=1.20.1-00 -y
kubeadm upgrade plan
kubeadm upgrade apply v1.20.1 --etcd-upgrade=false
kubectl uncordon mk8s-master-0
apt install kubelet=1.20.1-00 kubectl=1.20.1-00 -y
systemctl restart kubelet
