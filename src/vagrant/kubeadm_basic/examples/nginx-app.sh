#!/usr/bin/env bash

kubectl create -f /vagrant/examples/nginx-app.yaml
kubectl get nodes
kubectl get services
kubectl get pods
kubectl get rc

r="0"
while [ $r -ne "2" ]
do
   r=$(kubectl get pods | grep Running | wc -l)
   sleep 20
done

svcip=$(kubectl get services nginx  -o json | grep clusterIP | cut -f4 -d'"')
wget http://$svcip
kubectl delete rc --all
kubectl delete services --all
kubectl delete pod --all
