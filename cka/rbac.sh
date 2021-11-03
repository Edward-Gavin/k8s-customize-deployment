#!/bin/bash
kubectl create clusterrole deployment-clusterrole --verb=create --resource=deployments,daemonsets,statefulsets
kubectl create serviceaccount cicd-token -n app-team1
kubectl create rolebinding cicd-token --serviceaccount=app-team1:cicd-token --clusterrole=deployment-clusterrole -n app-team1
kubectl --as=system:serviceaccount:cicd-token get pods -n app-team1