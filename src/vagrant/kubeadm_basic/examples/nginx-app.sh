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

# Install Helm
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

# Get Tiller running
helm init

# Solved problem with `helm install` and `helm list` commands. Official Issue: https://github.com/kubernetes/helm/issues/2224
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'

# Install Nginx in port 32716
helm install stable/nginx-ingress

# Show information
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

# Test nginx
wget http://$svcip

kubectl delete rc --all
kubectl delete services --all
kubectl delete pod --all
