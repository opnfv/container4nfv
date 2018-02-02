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

# Get latest istio version, refer: https://git.io/getLatestIstio
if [ "x${ISTIO_VERSION}" = "x" ] ; then
  ISTIO_VERSION=$(curl -L -s https://api.github.com/repos/istio/istio/releases/latest | \
                  grep tag_name | sed "s/ *\"tag_name\": *\"\(.*\)\",*/\1/")
fi

ISTIO_DIR_NAME="istio-$ISTIO_VERSION"

cd /vagrant
curl -L https://git.io/getLatestIstio | sh -
mv $ISTIO_DIR_NAME istio-source
cd /vagrant/istio-source/

# Persistently append istioctl bin path to PATH env
echo 'export PATH="$PATH:/vagrant/istio-source/bin"' >> ~/.bashrc
echo "source <(kubectl completion bash)" >> ~/.bashrc
source ~/.bashrc

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

