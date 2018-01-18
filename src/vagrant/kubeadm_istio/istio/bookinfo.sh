#!/bin/bash
#
# Copyright (c) 2018 Huawei Technologies Canada Co., Ltd.
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

cd /vagrant/istio-source/
export PATH=$PWD/bin:$PATH

# Run the test application: bookinfo
kubectl apply -f <(istioctl kube-inject -f samples/bookinfo/kube/bookinfo.yaml)

# Wait for bookinfo deployed
kubectl get services
kubectl get pods

r="0"
while [ $r -ne "6" ]
do
   kubectl get pods
   r=$(kubectl get pods | grep Running | wc -l)
   sleep 60
done

# Validate the bookinfo app
export GATEWAY_URL=$(kubectl get po -l istio=ingress -n istio-system -o 'jsonpath={.items[0].status.hostIP}'):$(kubectl get svc istio-ingress -n istio-system -o 'jsonpath={.spec.ports[0].nodePort}')
curl -o /dev/null -s -w "%{http_code}\n" http://${GATEWAY_URL}/productpage

