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

bash ../src/cni/ovsdpdk/build.sh

# Build Clearwater project images
bash ../src/vagrant/kubeadm_clearwater/create_images.sh

# Generates Clearwater tarballs
for i in base astaire cassandra chronos bono ellis homer homestead homestead-prov ralf sprout
do
    docker save --output clearwater-$i.tar clearwater/$i
done

# Build vnf images
docker build -t container4nfv/ping ../src/vnf/ping/.
docker build -t container4nfv/virtio-user-ping ../src/vnf/virtio-user-ping/.

# Generate tar ball
docker save --output container4nfv-ping.tar container4nfv/ping
docker save --output container4nfv-virtio-user-ping.tar container4nfv/virtio-user-ping

