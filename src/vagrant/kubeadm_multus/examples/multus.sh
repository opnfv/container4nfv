#!/bin/bash

set -ex

#workaroud to fix dns pod issue
times=0

while [ $times -lt "3" ]
do
    kubectl get pods -n kube-system | grep kube-dns | grep -v Run | sed "s/ .*//" | \
        xargs -I {} kubectl delete pod -n kube-system {}
    sleep 20
    times+=1
done

kubectl apply -f /vagrant/examples/busybox.yaml
r="0"
while [ $r -ne "2" ]
do
   r=$(kubectl get pods | grep Running | wc -l)
   sleep 20
done
kubectl get pods --all-namespaces
kubectl get pods | grep Run | sed "s/ .*//" | xargs -I {} kubectl exec -i {} ip a
