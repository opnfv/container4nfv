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

wget https://storage.googleapis.com/kubernetes-helm/helm-v2.14.0-linux-amd64.tar.gz
tar xzvf helm-v2.14.0-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/
helm init
helm serve &
helm repo remove stable
helm repo add local http://127.0.0.1:8879

ISTIO_VERSION=1.1.8
ISTIO_DIR_NAME="istio-$ISTIO_VERSION"

cd /vagrant
wget https://github.com/istio/istio/releases/download/$ISTIO_VERSION/istio-$ISTIO_VERSION-linux.tar.gz

mv $ISTIO_DIR_NAME istio-source
cd /vagrant/istio-source/

# Persistently append istioctl bin path to PATH env
echo 'export PATH="$PATH:/vagrant/istio-source/bin"' >> ~/.bashrc
echo "source <(kubectl completion bash)" >> ~/.bashrc
source ~/.bashrc

kubectl create namespace istio-system
helm template install/kubernetes/helm/istio-init --name istio-init --namespace istio-system | kubectl apply -f -
kubectl get crds | grep 'istio.io\|certmanager.k8s.io' | wc -l
helm template install/kubernetes/helm/istio --name istio --namespace istio-system | kubectl apply -f -

# Validate the installation
kubectl get svc -n istio-system
kubectl get pods -n istio-system
kubectl get namespace -L istio-injection

r="1"
while [ $r -ne "0" ]
do
   sleep 30
   kubectl get pods -n istio-system
   r=$(kubectl get pods -n istio-system | egrep -v 'NAME|Running|Completed' | wc -l)
done
