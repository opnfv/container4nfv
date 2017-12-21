#!/bin/bash

set -ex

sudo mkdir /dockerdata-nfs
sudo chmod 755 /dockerdata-nfs
sudo kubeadm join --token 8c5adc.1cec8dbf339093f0 192.168.0.10:6443 || true

sudo apt-get install -y putty-tools
mkdir ~/.kube
echo "y\n" | plink -ssh -pw vagrant vagrant@master "cat ~/.kube/config" > ~/.kube/config
