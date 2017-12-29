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

sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-key adv -k 58118E89F3A912897C070ADBF76221572C52609D
cat << EOF | sudo tee /etc/apt/sources.list.d/docker.list
deb [arch=amd64] https://apt.dockerproject.org/repo ubuntu-xenial main
EOF
sudo apt-get install -y --allow-downgrades docker-engine=1.12.6-0~ubuntu-xenial

bash ../src/cni/ovsdpdk/build.sh

# Build Clearwater project images
bash ../src/vnf/clearwater-project/create_images.sh

# Generates Clearwater tarballs
for i in base astaire cassandra chronos bono ellis homer homestead homestead-prov ralf sprout
do 
    docker save --output clearwater-$i.tar clearwater/$i
done
