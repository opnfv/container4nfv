#!/usr/bin/env bash
set -eux

api_advertise_address=$1
service_cidr=$2
pod_network=$3
pod_network_cidr=$4
token='8c5adc.1cec8dbf339093f0'

curl -s http://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
sudo apt-get install -y docker.io
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni
rm -rf /var/lib/kubelet
sudo kubeadm init --api-advertise-addresses $api_advertise_address --service-cidr=$service_cidr --pod-network-cidr=$pod_network_cidr --token $token

if [ $pod_network_cidr = 'flannel' ]; then
    sudo kubectl apply -f http://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
else
    sudo kubectl apply -f http://git.io/weave-kube
fi
