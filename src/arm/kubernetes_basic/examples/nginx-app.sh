#!/bin/bash
#
# Copyright (c) 2017 arm Corporation
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

#Ref: src/vagrant/kubeadm_basic/examples/nginx-app.sh
#Revised a little

set -ex

kubectl create -f ./examples/nginx-app.yaml
kubectl get nodes
kubectl get services
kubectl get pods
kubectl get rc

r="0"
while [ $r -ne "2" ]
do
   r=$(kubectl get pods | grep Running | wc -l)
   sleep 60
done

svcip=$(kubectl get services nginx  -o json | grep clusterIP | cut -f4 -d'"')
sleep 10
wget http://$svcip
kubectl delete -f ./examples/nginx-app.yaml
kubectl get rc
kubectl get pods
kubectl get services
