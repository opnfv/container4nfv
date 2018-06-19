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

sudo kubeadm init --skip-preflight-checks --apiserver-advertise-address=192.168.1.10  --service-cidr=10.96.0.0/16 --pod-network-cidr=10.32.0.0/12 --token 8c5adc.1cec8dbf339093f0
mkdir ~/.kube
sudo cp /etc/kubernetes/admin.conf .kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config

cat << EOF | sudo tee /etc/systemd/system/k8s-proxy.service
[Unit]
Description=K8s Proxy Daemon

[Service]
ExecStart=/usr/bin/kubectl proxy --address=0.0.0.0 --accept-hosts='".*"' --port=8080

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl start k8s-proxy

sudo ovnkube -k8s-kubeconfig /home/vagrant/.kube/config -net-controller -loglevel=4 -k8s-apiserver=http://192.168.1.10:8080 -logfile=/var/log/openvswitch/ovnkube.log -init-master=master -cluster-subnet=10.32.0.0/12 -service-cluster-ip-range=10.96.0.0/16 -nodeport -nb-address=tcp://192.168.1.10:6631 -sb-address=tcp://192.168.1.10:6632 &
