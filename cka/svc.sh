#!/bin/bash
kubectl edit deployment front-end
  containers:
  - name: nginx
  image: nginx
  imagePullPolicy: Always
  ports:
  - name: http
    protocol: TCP
    containerPort: 80
kubectl expose deployment front-end --port=80 --target-port=80 --type=NodePort --name=front-end-svc