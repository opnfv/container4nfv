#!/usr/bin/env bash

rm -rf id_rsa authorized_keys
ssh-keygen  -t rsa -N ''  -f id_rsa
mv id_rsa.pub authorized_keys

kubectl delete rc --all
kubectl delete pods --all
kubectl delete configmap --all
kubectl create configmap yardstick-pub --from-file=authorized_keys
kubectl create configmap yardstick-prv --from-file=id_rsa
cp ~/admin.conf config
kubectl create configmap k8s-conf --from-file=config
kubectl create -f /vagrant/examples/yardstick.yaml
sleep 120
kubectl get nodes
kubectl get services
kubectl get pods
kubectl get rc
kubectl describe pods | grep -e "IP:" -e "^Name:"
