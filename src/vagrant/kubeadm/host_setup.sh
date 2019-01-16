#!/bin/bash

set -ex

cat << EOF | sudo tee /etc/hosts
127.0.0.1    localhost
192.168.1.5 registry
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
sudo apt-get install -y --allow-unauthenticated kubelet=1.12.2-00 kubeadm=1.12.2-00 kubectl=1.12.2-00 kubernetes-cni=0.6.0-00
echo 'Environment="KUBELET_EXTRA_ARGS=--feature-gates=DevicePlugins=true"' | sudo tee /etc/default/kubelet
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo modprobe ip_vs
sudo modprobe ip_vs_rr
sudo modprobe ip_vs_wrr
sudo modprobe ip_vs_sh
sudo modprobe br_netfilter
sudo modprobe nf_conntrack_ipv4

sudo swapoff -a
sudo systemctl daemon-reload
sudo systemctl stop kubelet
sudo systemctl start kubelet
