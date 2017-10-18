#!/usr/bin/env bash

kubectl create -f /vagrant/examples/nginx-app.yaml
kubectl get nodes
kubectl get services
kubectl get pods
kubectl get rc
sleep 120
svcip=$(kubectl get services nginx  -o json | grep clusterIP | cut -f4 -d'"')
wget http://$svcip
