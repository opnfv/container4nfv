#!/bin/bash

set -ex

sudo kubeadm init --apiserver-advertise-address=192.168.1.10  --service-cidr=192.168.1.0/24 --pod-network-cidr=10.244.0.0/24 --token 8c5adc.1cec8dbf339093f0
mkdir ~/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f /src/cni/ovsdpdk/kube_ovsdpdk.yml
kubectl apply -f /src/cni/ovsdpdk/kube_cniovsdpdk.yml
