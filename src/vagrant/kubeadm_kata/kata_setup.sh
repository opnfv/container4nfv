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

wget https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz
sudo tar -xvf go1.8.3.linux-amd64.tar.gz -C /usr/local/
mkdir -p $HOME/go/src
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

go get github.com/clearcontainers/tests
cd $GOPATH/src/github.com/clearcontainers/tests/.ci

echo "Install dependencies"
bash -f ./setup_env_ubuntu.sh

echo "Install shim"
bash -f ./install_shim.sh

echo "Install proxy"
bash -f ./install_proxy.sh

echo "Install runtime"
bash -f ./install_runtime.sh

echo "Install CRI-O"
bash -f ./install_crio.sh

sudo systemctl stop kubelet
echo "Modify kubelet systemd configuration to use CRI-O"
k8s_systemd_file="/etc/systemd/system/kubelet.service.d/10-kubeadm.conf"
sudo sed -i '/KUBELET_AUTHZ_ARGS/a Environment="KUBELET_EXTRA_ARGS=--container-runtime=remote --container-runtime-endpoint=/var/run/crio.sock --runtime-request-timeout=30m"' "$k8s_systemd_file"
sudo systemctl daemon-reload
sudo systemctl start kubelet
