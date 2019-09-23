#!/bin/bash

set -ex

sudo systemctl stop systemd-resolved
cat << EOF | sudo tee /etc/resolv.conf
nameserver 8.8.8.8
EOF

cat << EOF | sudo tee /etc/hosts
127.0.0.1    localhost
192.168.1.10 master
192.168.1.21 worker1
192.168.1.22 worker2
192.168.1.23 worker3
EOF

sudo apt-get update
sudo apt-get install -y docker.io

curl -s http://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y --allow-unauthenticated kubelet=1.15.2-00 kubeadm=1.15.2-00 kubectl=1.15.2-00 kubernetes-cni=0.7.5-00
sudo sed -i '9i\Environment="KUBELET_EXTRA_ARGS=--feature-gates=DevicePlugins=true"' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

sudo modprobe ip_vs
sudo modprobe ip_vs_rr
sudo modprobe ip_vs_wrr
sudo modprobe ip_vs_sh
sudo swapoff -a
sudo systemctl daemon-reload
sudo systemctl stop kubelet
sudo systemctl start kubelet
