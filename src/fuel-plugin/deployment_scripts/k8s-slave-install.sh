#!/usr/bin/env bash
set -eux

api_advertise_address=$1
token='8c5adc.1cec8dbf339093f0'

curl -s http://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y docker.io
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni
rm -rf /var/lib/kubelet
sudo kubeadm join --token $token $api_advertise_address || true
