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

static_ip=$(ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1)
echo "STATIC_IP is $static_ip."

git clone --recursive https://github.com/Metaswitch/clearwater-docker.git

# Set the configmaps
kubectl create configmap env-vars --from-literal=ZONE=default.svc.cluster.local

# Generate the yamls
cd clearwater-docker/kubernetes/
./k8s-gencfg --image_path=enriquetaso --image_tag=latest

# Expose Ellis
# The Ellis provisioning interface can then be accessed on static_ip:30080
cp ellis-svc.yaml ellis-svc.yaml.bkp
cat ellis-svc.yaml | sed "s/clusterIP: None/type: NodePort/" > ellis-svc.yaml.new
cat ellis-svc.yaml.new | sed "s/port: 80/port: 80\n    nodePort: 30080/" > ellis-svc.yaml
rm ellis-svc.yaml.new

# Bono configuration
# Have a static external IP address available that the load balancer can use
cp /vagrant/custom-bono-svc/bono-svc.yaml .

cd
kubectl apply -f clearwater-docker/kubernetes
kubectl get nodes
kubectl get services
kubectl get pods
kubectl get rc
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
