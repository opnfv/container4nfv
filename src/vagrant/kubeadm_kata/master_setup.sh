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

kubectl apply -f http://git.io/weave-kube-1.6

r=1
while [ "$r" -ne "0" ]
do
    sleep 30
    r=$(kubectl get pods -n kube-system | grep weave-net | grep -v Run | wc -l)
done

sudo systemctl restart crio
