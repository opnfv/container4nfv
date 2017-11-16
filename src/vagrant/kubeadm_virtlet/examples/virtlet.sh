#!/bin/bash

kubectl label node worker1 extraRuntime=virtlet
kubectl label node worker2 extraRuntime=virtlet
kubectl label node worker3 extraRuntime=virtlet
kubectl create configmap -n kube-system virtlet-config --from-literal=download_protocol=http --from-literal=image_regexp_translation=1 --from-literal=disable_kvm=y
kubectl create configmap -n kube-system virtlet-image-translations --from-file images.yaml
kubectl create -f /vagrant/examples/virtlet-ds.yaml

kubectl delete pod --all
kubectl create -f /vagrant/examples/cirros-vm.yaml
r="0"
while [ $r -ne "2" ]
do
   r=$(kubectl get pods | grep Running | wc -l)
   sleep 20
done
kubectl get pods -o json | grep podIP | cut -f4 -d'"' | xargs ping -c 4
