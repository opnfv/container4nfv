#!/bin/bash

sudo ifconfig br-dpdk 10.244.0.1/16 up

sudo kubeadm init --apiserver-advertise-address 192.168.1.10  --service-cidr=192.168.1.0/24 --pod-network-cidr=10.244.0.0/16 --token 8c5adc.1cec8dbf339093f0
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf
echo "export KUBECONFIG=$HOME/admin.conf" >> $HOME/.bash_profile

#kubectl apply -f http://git.io/weave-kube-1.6
#kubectl apply -f http://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
#kubectl apply -f http://docs.projectcalico.org/v2.1/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml
kubectl apply -f /vagrant/ovsdpdk/kube_ovsdpdk.yml
kubectl apply -f /src/cni/ovsdpdk/kube_cniovsdpdk.yml
