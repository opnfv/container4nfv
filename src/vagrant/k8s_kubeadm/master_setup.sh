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
sudo apt-get install -y --allow-downgrades kubelet=1.7.0-00 kubeadm=1.7.0-00 kubectl=1.7.0-00 kubernetes-cni=0.5.1-00

sudo kubeadm init --apiserver-advertise-address 192.168.1.10  --service-cidr=192.168.1.0/24 --pod-network-cidr=10.244.0.0/16 --token 8c5adc.1cec8dbf339093f0
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf
echo "export KUBECONFIG=$HOME/admin.conf" >> $HOME/.bash_profile

kubectl apply -f http://git.io/weave-kube-1.6
#kubectl apply -f http://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
#kubectl apply -f http://docs.projectcalico.org/v2.1/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml
