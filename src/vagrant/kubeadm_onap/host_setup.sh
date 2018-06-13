#!/bin/bash

set -ex

cat << EOF | sudo tee /etc/hosts
127.0.0.1    localhost
192.168.0.10 master
192.168.0.21 worker1
192.168.0.22 worker2
192.168.0.23 worker3
EOF

cat << EOF | sudo tee /etc/resolv.conf
search svc.cluster.local cluster.local
nameserver 10.96.0.10
nameserver 8.8.8.8
nameserver 8.8.4.4
options ndots:5 timeout:1 attempts:1
EOF


sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce

curl -s http://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
sudo apt-get install -y --allow-unauthenticated --allow-downgrades kubelet=1.8.2-00 kubeadm=1.8.2-00 kubectl=1.8.2-00 kubernetes-cni=0.5.1-00

sudo swapoff -a
sudo systemctl daemon-reload
sudo systemctl stop kubelet
sudo systemctl start kubelet
