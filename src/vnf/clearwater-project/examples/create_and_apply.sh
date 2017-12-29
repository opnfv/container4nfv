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

git clone --recursive https://github.com/Metaswitch/clearwater-docker.git

# Set the configmaps
kubectl create configmap env-vars --from-literal=ZONE=default.svc.cluster.local --from-literal=ADDITIONAL_SHARED_CONFIG=hss_hostname=hss.example.com\\nhss_realm=example.com

# Genereta the yamls
cd clearwater-docker/kubernetes/
./k8s-gencfg --image_path=<path to your repo> --image_tag=<tag for the images you want to use>

# Apply yamls
cd
kubectl apply -f clearwater-docker/kubernetes
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
kubectl delete rc --all
kubectl delete services --all
kubectl delete pod --all
