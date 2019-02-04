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

sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/katacontainers:/releases:/x86_64:/master/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/kata-containers.list"
curl -sL  http://download.opensuse.org/repositories/home:/katacontainers:/release/xUbuntu_$(lsb_release -rs)/Release.key | sudo apt-key add -
sudo -E apt-get update
sudo -E apt-get -y install kata-runtime kata-proxy kata-shim
sudo -E apt-get -y install libseccomp2

wget http://storage.googleapis.com/cri-containerd-release/cri-containerd-1.1.0.linux-amd64.tar.gz >& /dev/null
sudo tar -C / -xzf cri-containerd-1.1.0.linux-amd64.tar.gz
sudo systemctl start containerd
sudo mkdir -p /opt/cni/bin
sudo mkdir -p /etc/cni/net.d
sudo mkdir -p /etc/containerd
containerd config default | sudo tee  /etc/containerd/config.toml
sudo sed -i "/.*untrusted_workload_runtime.*/,+5s/runtime_type.*/runtime_type=\"io.containerd.runtime.v1.linux\"/" /etc/containerd/config.toml
sudo sed -i "/.*untrusted_workload_runtime.*/,+5s/runtime_engine.*/runtime_engine=\"kata-runtime\"/" /etc/containerd/config.toml
sudo systemctl restart containerd

cat << EOF | sudo tee /etc/systemd/system/kubelet.service.d/0-containerd.conf
[Service]
Environment="KUBELET_EXTRA_ARGS=--container-runtime=remote --runtime-request-timeout=15m --container-runtime-endpoint=unix:///run/containerd/containerd.sock"
EOF

sudo systemctl daemon-reload
sudo systemctl restart kubelet
