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

kubectl delete rc --all
kubectl apply -f /vagrant/examples/virtio-user.yaml
r="0"
while [ $r -ne "6" ]
do
   r=$(kubectl get pods --all-namespaces | grep ovsdpdk | grep Run | wc -l)
   sleep 60
done

kubectl delete rc --all
kubectl apply -f /vagrant/examples/virtio-user.yaml
r="0"
while [ $r -ne "2" ]
do
   r=$(kubectl get pods | grep Running | wc -l)
   sleep 60
done
kubectl get pods --all-namespaces
sleep 60
kubectl get pods -o wide | awk 'NF>1 && NR>1 {print $1}' | xargs -I {} kubectl exec -i {} vppctl ping 10.244.0.10
