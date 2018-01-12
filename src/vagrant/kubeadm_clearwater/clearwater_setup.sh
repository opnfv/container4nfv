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

# Get the static ip
static_ip=$(ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1)
echo "STATIC_IP is $static_ip."

# Move the custom Chart to the master node
mv -f /vagrant/clearwater/ .

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

# Wait to Tiller to start
kubectl -n kube-system get po
sleep 160

# Deploy Clearwater project
helm install --set config.ip=$static_ip ./clearwater

sleep 60

r="1"
while [ $r != "0" ]
do
    o=$(kubectl get pods)
    echo $o
    r=$( kubectl get pods | grep Pending | wc -l)
    sleep 60
done

q="1"
while [ $q != "0" ]
do
    o=$(kubectl get pods)
    echo $o
    q=$( kubectl get pods | grep ContainerCreating | wc -l)
    sleep 60
done

kubectl get nodes
kubectl get services
kubectl get pods
kubectl get rc
