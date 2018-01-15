#!/bin/bash

set -ex
export http_proxy=192.168.39.9:8118
export https_proxy=192.168.39.9:8118
sudo kubeadm init --apiserver-advertise-address=192.168.0.10  --service-cidr=10.96.0.0/24 --pod-network-cidr=10.32.0.0/12 --token 8c5adc.1cec8dbf339093f0
mkdir ~/.kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config

kubectl apply -f http://git.io/weave-kube-1.6
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
helm init
kubectl create clusterrolebinding --user system:serviceaccount:kube-system:default kube-system-cluster-admin --clusterrole cluster-admin
