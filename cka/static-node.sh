#!/bin/bash
kubectl describe node $(kubectl get nodes | grep Ready | awk 'print $1') | grep Taint| grep -vc NoSchedule > /opt/KUSC00402/kusc00402.txt