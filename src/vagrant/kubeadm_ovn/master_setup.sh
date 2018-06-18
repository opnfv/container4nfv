#!/bin/bash

set -ex

sudo kubeadm init --apiserver-advertise-address=192.168.1.10  --service-cidr=10.96.0.0/16 --pod-network-cidr=10.32.0.0/12 --token 8c5adc.1cec8dbf339093f0
mkdir ~/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo ovnkube -k8s-kubeconfig /home/vagrant/.kube/config -net-controller -loglevel=4 -k8s-apiserver=http://192.168.1.10:8080 -logfile=/var/log/openvswitch/ovnkube.log -init-master=master -cluster-subnet=10.32.0.0/12 -service-cluster-ip-range=10.96.0.0/16 -nodeport -nb-address=tcp://192.168.1.10:6631 -sb-address=tcp://192.168.1.10:6632 &

kubectl proxy --address=192.168.1.10 --accept-hosts=".*" --port=8080 &
