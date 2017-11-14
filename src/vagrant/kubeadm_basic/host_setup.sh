#!/bin/bash

set -ex

cat << EOF | sudo tee /etc/hosts
127.0.0.1    localhost
192.168.1.10 master
192.168.1.21 worker1
192.168.1.22 worker2
192.168.1.23 worker3
EOF

curl -s http://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y --allow-downgrades docker.io=1.12.6-0ubuntu1~16.04.1 kubelet=1.7.0-00 kubeadm=1.7.0-00 kubectl=1.7.0-00 kubernetes-cni=0.5.1-00

sudo rm -rf /var/lib/kubelet
sudo systemctl stop kubelet
sudo systemctl daemon-reload
sudo systemctl start kubelet
