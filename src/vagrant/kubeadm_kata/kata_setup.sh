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

cat << EOF | sudo tee /etc/apt/sources.list.d/cc-oci-runtime.list
deb http://download.opensuse.org/repositories/home:/clearcontainers:/clear-containers-3/xUbuntu_16.04/ /
EOF
curl -fsSL http://download.opensuse.org/repositories/home:/clearcontainers:/clear-containers-3/xUbuntu_16.04/Release.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y cc-oci-runtime

echo | sudo add-apt-repository ppa:projectatomic/ppa
sudo apt-get update
sudo apt-get install -y cri-o
sudo sed -i 's,runtime_untrusted_workload.*,runtime_untrusted_workload = "/usr/bin/cc-runtime",' /etc/crio/crio.conf
sudo sed -i 's,cgroup_manager.*,cgroup_manager = "cgroupfs",' /etc/crio/crio.conf
sudo sed -i 's,default_workload_trust.*,default_workload_trust = "untrusted",' /etc/crio/crio.conf
sudo sed -i 's,^registries.*, registries = [ "https://hub.docker.com/",' /etc/crio/crio.conf
sudo systemctl enable crio
sudo systemctl daemon-reload
sudo systemctl restart crio

sudo systemctl stop kubelet
echo "Modify kubelet systemd configuration to use CRI-O"
k8s_systemd_file="/etc/systemd/system/kubelet.service.d/10-kubeadm.conf"
sudo sed -i '/KUBELET_AUTHZ_ARGS/a Environment="KUBELET_EXTRA_ARGS=--container-runtime=remote --container-runtime-endpoint=/var/run/crio/crio.sock --runtime-request-timeout=30m"' "$k8s_systemd_file"
sudo systemctl daemon-reload
sudo systemctl start kubelet
