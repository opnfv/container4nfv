#!/usr/bin/env bash

set -e
HOME=`pwd`

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
sudo apt-get install -y docker.io
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni
sudo kubeadm join --token 8c5adc.1cec8dbf339093f0 192.168.1.10:6443 || true
echo "vagrant ssh master -c '/vagrant/examples/nginx-app.sh'"
