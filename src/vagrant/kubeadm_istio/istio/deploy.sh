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

# Deploy istio 0.4.0
cd /vagrant
curl -L https://git.io/getLatestIstio | sh - 
mv istio-0.4.0 istio-source
cd /vagrant/istio-source/
export PATH=$PWD/bin:$PATH
kubectl apply -f install/kubernetes/istio.yaml

# Validate the installation
kubectl get svc -n istio-system
kubectl get pods -n istio-system

r="0"
while [ $r -ne "4" ]
do
   kubectl get pods -n istio-system
   r=$(kubectl get pods -n istio-system | grep Running | wc -l)
   sleep 60
done

