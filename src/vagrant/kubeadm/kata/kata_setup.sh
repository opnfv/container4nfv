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

ARCH=$(arch)
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/katacontainers:/releases:/${ARCH}:/master/xUbuntu_$(lsb_release -rs)/ /' > /etc/apt/sources.list.d/kata-containers.list"
curl -sL  http://download.opensuse.org/repositories/home:/katacontainers:/releases:/${ARCH}:/master/xUbuntu_$(lsb_release -rs)/Release.key | sudo apt-key add -
sudo -E apt-get update
sudo -E apt-get -y install kata-runtime kata-proxy kata-shim
sudo -E apt-get -y install libseccomp2

wget https://github.com/opencontainers/runc/releases/download/v1.0.0-rc6/runc.amd64
sudo cp runc.amd64 /usr/sbin/runc
sudo chmod 755 /usr/sbin/runc
wget http://github.com/containerd/containerd/releases/download/v1.2.2/containerd-1.2.2.linux-amd64.tar.gz >& /dev/null
sudo tar -C /usr/local -xzf containerd-1.2.2.linux-amd64.tar.gz
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.13.0/crictl-v1.13.0-linux-amd64.tar.gz >& /dev/null
sudo tar -C /usr/local/bin -xzf crictl-v1.13.0-linux-amd64.tar.gz
echo "runtime-endpoint: unix:///run/containerd/containerd.sock" | sudo tee /etc/crictl.yaml
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.13.0/critest-v1.13.0-linux-amd64.tar.gz >& /dev/null
sudo tar C /usr/local/bin -xzf critest-v1.13.0-linux-amd64.tar.gz
sudo cp /vagrant/kata/containerd.service /etc/systemd/system/
sudo systemctl start containerd
sudo mkdir -p /opt/cni/bin
sudo mkdir -p /etc/cni/net.d
sudo mkdir -p /etc/containerd
containerd config default | sudo tee  /etc/containerd/config.toml
sudo sed -i "s,\[plugins.cri.registry.mirrors\],\[plugins.cri.registry.mirrors\]\n        \[plugins.cri.registry.mirrors.\"registry:5000\"\]\n          endpoint = \[\"http://registry:5000\"\]," /etc/containerd/config.toml
sudo sed -i "/.*untrusted_workload_runtime.*/,+5s/runtime_type.*/runtime_type=\"io.containerd.runtime.v1.linux\"/" /etc/containerd/config.toml
sudo sed -i "/.*untrusted_workload_runtime.*/,+5s/runtime_engine.*/runtime_engine=\"kata-runtime\"/" /etc/containerd/config.toml
sudo systemctl restart containerd

cat << EOF | sudo tee /etc/systemd/system/kubelet.service.d/0-containerd.conf
[Service]
Environment="KUBELET_EXTRA_ARGS=--container-runtime=remote --runtime-request-timeout=15m --container-runtime-endpoint=unix:///run/containerd/containerd.sock"
EOF

sudo systemctl daemon-reload
sudo systemctl restart kubelet
