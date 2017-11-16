#!/bin/bash

set -ex

kubectl delete rc --all
kubectl apply -f /vagrant/examples/virtio-user.yaml
r="0"
while [ $r -ne "6" ]
do
   r=$(kubectl get pods --all-namespaces | grep ovsdpdk | grep Run | wc -l)
   sleep 20
done

kubectl delete rc --all
kubectl apply -f /vagrant/examples/virtio-user.yaml
r="0"
while [ $r -ne "2" ]
do
   r=$(kubectl get pods | grep Running | wc -l)
   sleep 20
done
kubectl get pods --all-namespaces
ping -c4 10.244.0.101 || ping -c4 10.244.0.102
