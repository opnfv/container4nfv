#!/bin/bash
#
# Copyright (c) 2017 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -ex

cat << EOF | sudo tee /etc/hosts
127.0.0.1  localhost
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
sudo apt-get install -y --allow-unauthenticated kubelet=1.10.5-00 kubeadm=1.10.5-00 kubectl=1.10.5-00 kubernetes-cni=0.6.0-00


sudo swapoff -a
sudo systemctl stop kubelet
sudo rm -rf /var/lib/kubelet
sudo systemctl daemon-reload
sudo systemctl start kubelet


sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5EDB1B62EC4926EA
sudo apt-get update -y
sudo apt-get install software-properties-common -y
sudo apt-add-repository cloud-archive:queens -y
sudo apt-get update -y

#sudo apt-get build-dep dkms -y
sudo apt-get install python-six openssl python-pip -y
sudo -H pip install --upgrade pip
sudo -H pip install ovs
#sudo apt-get install openvswitch-datapath-dkms -y
sudo apt-get install openvswitch-switch openvswitch-common -y
sudo apt-get install ovn-central ovn-common ovn-host -y
sudo modprobe vport-geneve

wget https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz
sudo tar -xvf go1.8.3.linux-amd64.tar.gz -C /usr/local/
mkdir -p $HOME/go/src
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
git clone https://github.com/openvswitch/ovn-kubernetes -b v0.3.0
cd ovn-kubernetes/go-controller
make
sudo make install
