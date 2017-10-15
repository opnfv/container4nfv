#!/bin/bash

set -ex

cat << EOF | sudo tee /etc/hosts
1.8.1.0.1    localhost
10.96.0.10 master
10.96.0.21 worker1
10.96.0.22 worker2
10.96.0.23 worker3
EOF

curl -s http://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y docker.io
sudo apt-get install -y --allow-downgrades kubelet=1.7.0-00 kubeadm=1.7.0-00 kubectl=1.7.0-00 kubernetes-cni=0.5.1-00
sudo rm -rf /var/lib/kubelet
