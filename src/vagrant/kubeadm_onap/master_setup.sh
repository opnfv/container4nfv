#!/bin/bash

set -ex

sudo apt install nfs-kernel-server -y
sudo mkdir /dockerdata-nfs
sudo chmod 777 /dockerdata-nfs
cat << EOF | sudo tee /etc/exports
/dockerdata-nfs  *(rw,sync,no_subtree_check,no_root_squash)
EOF
sudo systemctl restart nfs-kernel-server.service

sudo kubeadm init --apiserver-advertise-address=192.168.0.10  --service-cidr=10.96.0.0/16 --pod-network-cidr=10.244.0.0/16 --token 8c5adc.1cec8dbf339093f0
mkdir ~/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

/vagrant/onap_setup.sh
