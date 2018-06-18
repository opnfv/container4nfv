#!/bin/bash

set -ex
sudo kubeadm join --discovery-token-unsafe-skip-ca-verification --token 8c5adc.1cec8dbf339093f0 192.168.1.10:6443 || true

sudo apt-get install -y putty-tools
mkdir ~/.kube
echo "y\n" | plink -ssh -pw vagrant vagrant@master "cat ~/.kube/config" > ~/.kube/config || true

CENTRAL_IP=192.168.1.10
NODE_NAME=$(hostname)
TOKEN="8c5adc.1cec8dbf339093f0"

sudo ovnkube -k8s-kubeconfig /home/vagrant/.kube/config -loglevel=4 \
    -logfile="/var/log/openvswitch/ovnkube.log" \
    -k8s-apiserver="http://$CENTRAL_IP:8080" \
    -init-node="$NODE_NAME"  \
    -nodeport \
    -nb-address="tcp://$CENTRAL_IP:6631" \
    -sb-address="tcp://$CENTRAL_IP:6632" -k8s-token="$TOKEN" \
    -init-gateways \
    -service-cluster-ip-range=10.96.0.0/16 \
    -cluster-subnet=10.32.0.0/12 &
