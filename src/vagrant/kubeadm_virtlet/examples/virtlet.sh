#!/bin/bash

kubectl label node worker1 extraRuntime=virtlet
kubectl label node worker2 extraRuntime=virtlet
kubectl label node worker3 extraRuntime=virtlet
kubectl create configmap -n kube-system virtlet-config --from-literal=download_protocol=http --from-literal=image_regexp_translation=1 --from-literal=disable_kvm=y
kubectl create configmap -n kube-system virtlet-image-translations --from-file images.yaml
kubectl create -f virtlet-ds.yaml
kubectl create -f cirros-vm.yaml
