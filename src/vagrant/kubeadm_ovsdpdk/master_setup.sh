#!/bin/bash

set -ex

sudo kubeadm init --apiserver-advertise-address=192.168.1.10  --service-cidr=192.168.1.0/24 --pod-network-cidr=10.244.0.0/24 --token 8c5adc.1cec8dbf339093f0
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf
echo "export KUBECONFIG=$HOME/admin.conf" >> $HOME/.bash_profile

kubectl apply -f /vagrant/ovsdpdk/kube_ovsdpdk.yml
kubectl apply -f /src/cni/ovsdpdk/kube_cniovsdpdk.yml
